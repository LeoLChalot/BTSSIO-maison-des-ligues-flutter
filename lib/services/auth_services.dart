import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
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
  static final String _baseUrl = "${dotenv.env['BASE_URL']}/m2l";
  static final AuthService _authService = Get.find<AuthService>();
  static Future<void> _saveUserInfo(
      {required String pseudo, required String token}) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "access_token", value: token);
    await storage.write(key: "pseudo", value: pseudo);
  }

  /*
  * Authentication - Process the data to authenticate user
  * @returns - An User object.
  */
  static Future<User> signin(String login, String password) async {
    final url = Uri.parse("$_baseUrl/user/connexion");
    final headers = {
      "Accept": "*/*",
      "Content-Type": "application/json",
    };
    final body = jsonEncode({"login": login, "mot_de_passe": password});
    final response = await http.post(url, headers: headers, body: body);
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      final user = jsonDecode(response.body)["infos"]["utilisateur"];
      debugPrint(user.toString());
      final isAdmin = user["isAdmin"];
      final token = user["token"];
      if (isAdmin == true) {
        _authService.setIsPremium(!(_authService.isPremium.value));
      }

      await _saveUserInfo(pseudo: user["pseudo"], token: token);
      return User.fromData(user);
    } else if (response.statusCode == 404) {
      return User.fromData({"pseudo": "Unknown", "isAdmin": false});
    } else {
      throw UserLoginException(
        message: "Login failed. Status code: ${response.statusCode}",
      );
    }
  }

  /*
  * LogOut - LogOut the user, and delete all Local Storage
  * @returns - Void.
  */
  static Future<void> logout() async {
    const storage = FlutterSecureStorage();
    try {
      await storage.deleteAll();
      _authService.setIsPremium(!_authService.isPremium.value);
    } catch (error) {
      throw UserLoginException(message: "Logout error: $error");
    }
  }
}
