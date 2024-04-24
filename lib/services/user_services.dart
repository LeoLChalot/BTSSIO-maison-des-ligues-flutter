import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class UserService {
  static final String _baseUrl = "${dotenv.env['BASE_URL']}/m2l";

  /*
  * Processes the data, and returns an instance of User object.
  * @returns - A User object.
  */
  static Future<User> getUser(String pseudo) async {
    try {
      final url = "$_baseUrl/user/pseudo/$pseudo";
      debugPrint("In getUser() => $url");
      final response = await http.get(Uri.parse(url));
      debugPrint(response.body.toString());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromData(data["infos"]["utilisateur"]);
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data - Delete the user targeted by the given [ID]
  * @return - A boolean
  */
  static Future<bool> deleteUser(String pseudo) async {
    final url = Uri.parse("$_baseUrl/user/delete/$pseudo");
    debugPrint("In deleteArticle() => $url");
    final response = await http.delete(url);
    return response.statusCode == 200;
  }

  /*
  * Processes the data - Update the user targeted by the given [ID]
  * @return - A boolean
  */
  static Future<bool> updateUser(Map<String, dynamic> user) async {
    final url = Uri.parse("$_baseUrl/user/update/profil/${user['id']}");
    final headers = {"Content-Type": "application/json"};
    var updatedUser = {};
    user.forEach((key, value) {
      if (key != 'id') {
        updatedUser[key] = value.toString();
      }
    });
    final body = jsonEncode(updatedUser);
    final response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw UserUpdateException(
        message: "Error updating user: ${response.reasonPhrase}",
        statusCode: response.statusCode,
      );
    }
  }

  static Future<bool> togglePrivilege(String id) async {
    try {
      final url = "$_baseUrl/admin/user/role/$id";
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: "access_token");

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.put(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        // Gérer la réponse réussie
        debugPrint('Rôle mis à jour avec succès.');
        return true;
      } else {
        // Gérer les erreurs de requête
        debugPrint(
            'Erreur lors de la modification du rôle de l\'utilisateur: ${response.reasonPhrase}');
        return false;
      }
    } catch (error) {
      // Gérer les erreurs
      debugPrint('Erreur lors de la mise à jour du rôle: $error');
      return false;
    }
  }
}
