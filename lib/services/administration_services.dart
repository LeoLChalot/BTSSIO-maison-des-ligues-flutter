import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';

//----------------------------------------------------//
//                  ADMIN RESERVED                    //
//----------------------------------------------------//
//          All the following methods in              //
//        AdministrationServices require an           //
//       Administrator authentication token           //
//                  to be executed                    //
//----------------------------------------------------//

class AdministrationServices {
  static final String _baseUrl = "${dotenv.env['BASE_URL']}/m2l";

  static Future<String> _getAccessToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: "access_token") ?? '';
  }

  //----------------------------------------------------//
  //                    SHOP SECTION                    //
  //----------------------------------------------------//

  /*
  * Processes the data, and create the item
  * @return - A boolean
  */
  static Future<Map<String, dynamic>> createCategorie(String nom) async {
    final token = await _getAccessToken();
    final url = Uri.parse("$_baseUrl/admin/categorie/new");
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Bearer $token",
    };
    final body = jsonEncode({"nom": nom});

    final response = await http.post(url, headers: headers, body: body);

    final isSuccess = response.statusCode == 200;
    final message = isSuccess
        ? "Catégorie a jouté !"
        : response.statusCode == 404
            ? "La catégorie existe déjà..."
            : "Une erreur inattendue s'est produite (code: ${response.statusCode})";

    return {
      "status": response.statusCode,
      "success": isSuccess,
      "message": message,
    };
  }

  /*
  * Processes the data, and create the item
  * @return - True or False.
  */
  static Future<bool> createArticle(
      XFile? image, Map<String, dynamic> article) async {
    final token = await _getAccessToken();
    final url = Uri.parse("$_baseUrl/admin/article/new");

    final multipartRequest = http.MultipartRequest('POST', url);

    // Add image if available
    if (image != null) {
      final imageBytes = await image.readAsBytes();
      final imagePart = http.MultipartFile.fromBytes(
        'photo',
        imageBytes,
        filename: 'product_image.jpg',
      );
      multipartRequest.files.add(imagePart);
    }

    // Set headers and article data
    multipartRequest.headers['Content-Type'] = 'multipart/form-data';
    multipartRequest.headers['Authorization'] = 'Bearer $token';
    article.forEach((key, value) {
      multipartRequest.fields[key] = value.toString();
    });

    // Send the request
    final streamedResponse = await multipartRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Handle response
    if (response.statusCode == 200) {
      debugPrint('Produit ajouté avec succès.');
      return true;
    } else {
      debugPrint(
          'Erreur lors de l\'ajout du produit: ${response.reasonPhrase}');
      return false;
    }
  }

  /*
  * Processes the data, and update the item targeted by the given [body.id]
  * @return - A boolean
  */
  static Future<bool> updateArticle(XFile? image, article) async {
    final token = await _getAccessToken();
    final url = Uri.parse("$_baseUrl/admin/article/${article['id']}");

    try {
      final imageUploadRequest = http.MultipartRequest('PUT', url);
      if (image != null) {
        List<int> imageBytes = await image.readAsBytes();
        final imagePart = http.MultipartFile.fromBytes(
          'photo',
          imageBytes,
          filename: 'product_image.jpg', // Nom du fichier à envoyer
        );
        imageUploadRequest.files.add(imagePart);
        debugPrint("IMAGE PART => ${imagePart.toString()}");
      }
      // Set headers and article data
      imageUploadRequest.headers['Content-Type'] = 'multipart/form-data';
      imageUploadRequest.headers['Authorization'] = 'Bearer $token';
      article.forEach((key, value) {
        if (key != 'id') {
          imageUploadRequest.fields[key] = value.toString();
        }
      });

      // Send Multipart Request
      final streamedResponse = await imageUploadRequest.send();
      // Wait for any Response
      final response = await http.Response.fromStream(streamedResponse);

      // Handle response
      if (response.statusCode == 200) {
        debugPrint('Produit mis à jour avec succès.');
        return true;
      } else {
        debugPrint(
            'Erreur lors de la modification du produit: ${response.reasonPhrase}');
        return false;
      }
    } catch (error) {
      // Manage Errors
      debugPrint('Erreur lors de l\'envoi de la requête: $error');
      return false;
    }
  }

  /*
  * Processes the data, and delete the item targeted by the given [ID]
  * @return - A boolean
  */
  static Future<bool> deleteArticle(String id) async {
    final token = await _getAccessToken();
    final url = Uri.parse("$_baseUrl/admin/article/$id");
    try {
      final response = await http.delete(url, headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Bearer $token",
      });
      return response.statusCode == 200;
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data, and returns a list of items in the given [category_id]
  * @returns - A list of Article objects.
  */
  static Future<Map<String, dynamic>> getCommandesStatistiques() async {
    final token = await _getAccessToken();
    final url = Uri.parse("$_baseUrl/admin/commandes/all");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["infos"]["statistiques"] as Map;
        final statistiques = {
          "totalCommandes": data["totalCommandes"],
          "nombreCommandesSemainePrecedente":
              data["nombreCommandesSemainePrecedente"],
          "nombreCommandesSemaineActuelle":
              data["nombreCommandesSemaineActuelle"],
          "pourcentage": data["pourcentage"] ?? data["totalCommandes"] * 10000,
        };
        debugPrint(statistiques.toString());
        return statistiques;
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  //----------------------------------------------------//
  //                    USERS SECTION                   //
  //----------------------------------------------------//

  /*
  * Processes the data, and returns a list of Users objects.
  * @returns - A list of Users objects.
  */
  static Future<List<User>> getAllUsers() async {
    final token = await _getAccessToken();
    final url = Uri.parse("$_baseUrl/admin/users/all");

    try {
      final headers = {"Authorization": "Bearer $token"};
      final response = await http.get(url, headers: headers);

      debugPrint(
          "TOKEN => $token\nURL => $url\nRESPONSE => ${response.body.toString()}");

      if (response.statusCode == 200) {
        debugPrint(response.body.toString());
        final users = jsonDecode(response.body)["infos"]["users"];
        final list = users.map<User>((user) => User.fromData(user)).toList();
        debugPrint(list.toString());
        return list;
      } else {
        throw GetAllUsersException(
          message: "Failed to retrieve users (code: ${response.statusCode})",
        );
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data, and update the user role.
  * @returns - True or False.
  */
  static Future<bool> togglePrivilege(String id) async {
    final url = Uri.parse("$_baseUrl/admin/user/role/$id");
    final token = await _getAccessToken();
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.put(url, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw UpdateUserPrivilegeException(
        message: "Error toggling user privilege: ${response.reasonPhrase}",
        statusCode: response.statusCode,
      );
    }
  }
}
