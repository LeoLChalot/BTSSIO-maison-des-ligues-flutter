import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:maison_des_ligues_drawer/models/categorie_model.dart';

import '../models/article_model.dart';

class BoutiqueServices {
  static final String _baseUrl = "${dotenv.env['BASE_URL']}/m2l";

  // static const String _baseUrl = "http://192.168.242.199:3000/m2l";

  /*
  * Processes the data, and returns a list of Article objects.
  * @returns - A list of Article objects.
  */
  static Future<List<Article>> getAllArticles() async {
    try {
      debugPrint("In getAllArticles() => $_baseUrl/boutique/articles/all");
      final response =
          await http.get(Uri.parse("$_baseUrl/boutique/articles/all"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["infos"]["articles"] as List;
        debugPrint(data.toString());
        return data
            .map<Article>((article) => Article.fromData(article))
            .toList();
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data, and returns a list of items in the given [category_id]
  * @returns - A list of Article objects.
  */
  static Future<List<Article>> getArticleByCategory(String categorieId) async {
    try {
      debugPrint("In getArticleByCategory()");
      final response = await http.get(
          Uri.parse("$_baseUrl/boutique/articles/categorie/id/$categorieId"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["infos"]["articles"] as List;
        debugPrint(data.toString());

        return data
            .map<Article>((article) => Article.fromData(article))
            .toList();
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data, and returns the item targeted by the given [ID]
  * @returns - An Article object.
  */
  static Future<Article> getArticleById(String productId) async {
    try {
      debugPrint("In getAllArticles()");
      final response = await http
          .get(Uri.parse("$_baseUrl/boutique/articles/id/$productId"));
      if (response.statusCode == 200) {
        final data = await jsonDecode(response.body);
        return Article.fromData(data["infos"]["article"]);
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data, and returns the item targeted by the given [name]
  * @returns - An Article object.
  */
  static Future<Article> getArticleByName(String productName) async {
    try {
      debugPrint("In getAllArticles()");
      final response = await http
          .get(Uri.parse("$_baseUrl/boutique/articles/nom/$productName"));
      if (response.statusCode == 200) {
        final data = await jsonDecode(response.body);
        return Article.fromData(data["infos"]["article"]);
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data, and returns a list of Category objects.
  * @returns - A list of Categorie objects.
  */
  static Future<List<Categorie>> getAllCategories() async {
    try {
      debugPrint("In getAllCategories() => $_baseUrl/boutique/categories/all");
      final response =
          await http.get(Uri.parse("$_baseUrl/boutique/categories/all"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["infos"]["categories"] as List;
        return data
            .map<Categorie>((categorie) => Categorie.fromData(categorie))
            .toList();
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data, and returns the item targeted by the given [ID]
  * @returns - A Categorie object.
  */
  static Future<Categorie> getCategorieById(String categoryId) async {
    try {
      debugPrint("In getCategorieById() => $categoryId");
      final response = await http
          .get(Uri.parse("$_baseUrl/boutique/categorie/id/$categoryId"));
      if (response.statusCode == 200) {
        final data = await jsonDecode(response.body);
        debugPrint("DATA => ${data["infos"]["categorie"]}");
        return Categorie.fromData(data["infos"]["categorie"]);
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Administrator use only, using the token provided in Headers
  *
  * Processes the data, and create the item
  * @return - A boolean
  */
  static Future<Map> createCategorie(String nom) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: "access_token");
      final url = Uri.parse("$_baseUrl/admin/categorie/new");
      var headers = {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Bearer $token"
      };
      final body = jsonEncode({
        "nom": nom,
      });

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = {
          "status": response.statusCode,
          "success": false,
          "message": "Catégorie ajouté !"
        };
        return data;
      } else if (response.statusCode == 404) {
        final data = {
          "status": response.statusCode,
          "success": false,
          "message": "La catégorie existe déjà..."
        };
        return data;
      } else {
        final data = {
          "status": response.statusCode,
          "success": false,
          "message": "Une erreur inatendue s'est produite"
        };
        return data;
      }
    } catch (error) {
      // Gérer les erreurs
      debugPrint('Erreur lors de l\'ajout de la categoreie: $error');
      rethrow;
    }
  }

  /*
  * Administrator use only, using the token provided in Headers
  *
  * Processes the data, and delete the item targeted by the given [ID]
  * @return - A boolean
  */
  static Future<bool> deleteArticle(String id) async {
    try {
      // Create storage
      const storage = FlutterSecureStorage();
      // Read value
      String? token = await storage.read(key: "access_token");
      debugPrint("Token récupéré !\nToken : $token");
      debugPrint("In deleteArticle()");
      var headers = {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Bearer $token"
      };

      final response = await http
          .delete(Uri.parse("$_baseUrl/admin/article/$id"), headers: headers);
      return (response.statusCode == 200) ? true : false;
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Administrator use only, using the token provided in Headers
  *
  * Processes the data, and update the item targeted by the given [body.id]
  * @return - A boolean
  */
  static Future<bool> updateArticle(XFile? image, article) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: "access_token");
      final url = Uri.parse("$_baseUrl/admin/article/");

      final imageUploadRequest = http.MultipartRequest(
        'PUT',
        url,
      );
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
      // Set headers:
      imageUploadRequest.headers['Content-Type'] =
          'multipart/form-data'; // Required for multipart requests
      imageUploadRequest.headers['Authorization'] = 'Bearer $token';
      // Ajouter les autres données du produit au multipart request
      imageUploadRequest.fields['id'] = article["id"];
      imageUploadRequest.fields['nom'] = article["nom"];
      imageUploadRequest.fields['description'] = article["description"];
      imageUploadRequest.fields['prix'] = article["prix"];
      imageUploadRequest.fields['quantite'] = article["quantite"];
      imageUploadRequest.fields['categorie_id'] = article["categorie_id"];

      // Envoyer la requête multipart
      final streamedResponse = await imageUploadRequest.send();

      // Attendre la réponse
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Gérer la réponse réussie
        debugPrint('Produit mis à jour avec succès.');
        return true;
      } else {
        // Gérer les erreurs de requête
        debugPrint(
            'Erreur lors de la modification du produit: ${response.reasonPhrase}');
        return false;
      }
    } catch (error) {
      // Gérer les erreurs
      debugPrint('Erreur lors de la modification du produit: $error');
      return false;
    }
  }

  /*
  * Administrator use only, using the token provided in Headers
  *
  * Processes the data, and create the item
  * @return - A boolean
  */
  static Future<bool> createArticle(XFile? image, article) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: "access_token");
      final url = Uri.parse("$_baseUrl/admin/article");

      final imageUploadRequest = http.MultipartRequest(
        'POST',
        url,
      );

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

      // Set headers:
      imageUploadRequest.headers['Content-Type'] =
          'multipart/form-data'; // Required for multipart requests
      imageUploadRequest.headers['Authorization'] = 'Bearer $token';
      // Ajouter les autres données du produit au multipart request
      imageUploadRequest.fields['nom'] = article["nom"];
      imageUploadRequest.fields['description'] = article["description"];
      imageUploadRequest.fields['prix'] = article["prix"];
      imageUploadRequest.fields['quantite'] = article["quantite"];
      imageUploadRequest.fields['categorie_id'] = article["categorie_id"];

      // Envoyer la requête multipart
      final streamedResponse = await imageUploadRequest.send();

      // Attendre la réponse
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Gérer la réponse réussie
        debugPrint('Produit ajouté avec succès.');
        return true;
      } else {
        // Gérer les erreurs de requête
        debugPrint(
            'Erreur lors de l\'ajout du produit: ${response.reasonPhrase}');
        return false;
      }
    } catch (error) {
      // Gérer les erreurs
      debugPrint('Erreur lors de l\'ajout du produit: $error');
      return false;
    }
  }
}
