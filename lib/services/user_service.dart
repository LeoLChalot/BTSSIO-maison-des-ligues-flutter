import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class UserService {
  static final String _baseUrl = "${dotenv.env['BASE_URL']}/m2l";

  /*
  * Administrator use only, using the token provided in Headers
  *
  * Processes the data, and returns a list of Users objects.
  * @returns - A list of Users objects.
  */
  static Future<List<User>> getAllUsers() async {
    try {
      final url = "$_baseUrl/admin/users/all";
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: "access_token");
      debugPrint("In getAllUsers() => $url\nToken : $token");
      final headers = {"Authorization": "Bearer $token"};
      debugPrint("After Headers");
      final response = await http.get(Uri.parse(url), headers: headers);
      debugPrint("After Response");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("DATA GET USERS => ${data.toString()}");
        final listeUtilisateurs = data["infos"]["users"];
        debugPrint("LISTE UTILISATEURS => $listeUtilisateurs");
        return listeUtilisateurs
            .map<User>((user) => User.fromData(user))
            .toList();
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

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
  * Processes the data, and delete the user targeted by the given [ID]
  * @return - A boolean
  */
  static Future<bool> deleteUser(String pseudo) async {
    try {
      final url = "$_baseUrl/user/delete/$pseudo";
      debugPrint("In deleteArticle() => $url");

      final response = await http.delete(Uri.parse(url));
      return (response.statusCode == 200) ? true : false;
    } catch (error) {
      return Future.error(error);
    }
  }

  static Future<bool> updateUser(user) async {
    try {
      final headers = {"Content-Type": "application/json"};

      final body = jsonEncode({
        "prenom": user["prenom"],
        "nom": user["nom"],
        "pseudo": user["pseudo"],
        "email": user["email"],
        "mot_de_passe": user["mot_de_passe"]
      });
      debugPrint(user["id"]);
      debugPrint(body.toString());

      final url = "$_baseUrl/user/update/profil/${user["id"]}";
      debugPrint(url);

      final response =
          await http.put(Uri.parse(url), headers: headers, body: body);
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        // Gérer la réponse réussie
        debugPrint('Utilisateur mis à jour avec succès.');
        return true;
      } else {
        // Gérer les erreurs de requête
        debugPrint(
            'Erreur lors de la modification de l\'utilisateur: ${response.reasonPhrase}');
        return false;
      }
    } catch (error) {
      // Gérer les erreurs
      debugPrint('Erreur lors de la modification du produit: $error');
      return false;
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
