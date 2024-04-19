import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService extends GetxService {
  Future<AuthService> init() async => this;
  final RxBool isPremium = false.obs;

  void setIsPremium(bool newValue) {
    isPremium.value = newValue;
    debugPrint("New value = $newValue, isPremium = ${isPremium.value}");
  }
}

class Authentication {
  static final String _baseUrl = "${dotenv.env['BASE_URL']}/m2l/user";
  // static const String _baseUrl = "http://192.168.1.30:3000/m2l/user";
  // static const String _baseUrl = "http://192.168.242.199:3000/m2l/user";
  static final AuthService _authService = Get.find<AuthService>();

  static Future<User> signin(String login, String password) async {
    // Vérification de l'URL de requête API
    debugPrint("$_baseUrl/connexion");
    try {
      // Définition du headers de la requête
      var headers = <String, String>{
        "Accept": "*/*",
        'Content-Type': 'application/json',
      };

      // Mise en place au format JSON du body de la requête
      var body = jsonEncode(
          <String, dynamic>{"login": login, "mot_de_passe": password});

      // Envoi de la requête de connexion
      final response = await http.post(Uri.parse("$_baseUrl/connexion"),
          headers: headers, body: body);

      // DEBUG - Affichage du status de la réponse à la requête de connexion
      debugPrint("StatusCode => ${response.statusCode.toString()}");

      // Si les identifiants sont vérifiés
      if (response.statusCode == 200) {
        // On initialise le storage de l'appareil
        const storage = FlutterSecureStorage();
        final data = await jsonDecode(response.body)["infos"]["utilisateur"];
        debugPrint(
            "${data["pseudo"]}\n${data["isAdmin"]}\n${data["jwt_token"]}");
        if (data["isAdmin"] == true) {
          final user = User.fromData({
            "pseudo": data["pseudo"],
            "isAdmin": 1,
            "token": data["jwt_token"]
          });
          _authService.setIsPremium(!(_authService.isPremium.value));
          await storage.write(key: "access_token", value: user.token);
          await storage.write(key: "pseudo", value: user.pseudo);
          return user;
        }
        return User.fromData({"pseudo": data["pseudo"], "isAdmin": false});
      } else if (response.statusCode == 404) {
        // Handle Not Found (404) case (optional: return a specific User object)
        return User.fromData({"pseudo": "Unknown", "isAdmin": false});
      } else {
        throw UserLoginException(
            // Create a custom exception
            message: "Login failed. Status code: ${response.statusCode}");
      }
    } catch (error) {
      throw UserLoginException(
          message: "An error occurred: $error"); // More specific error message
    }
  }
}
