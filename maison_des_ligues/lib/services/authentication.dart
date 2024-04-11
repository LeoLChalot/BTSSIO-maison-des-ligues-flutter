import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:maison_des_ligues/models/user_model.dart';

class Authentication {
  static final String _baseUrl = "${dotenv.env['BASE_URL']}/m2l/user";

  static Future<User> signin(String login, String password) async {
    try {
      debugPrint("In signin()");
      debugPrint("LOGIN : $login\nMDP : $password");
      debugPrint("$_baseUrl/connexion");

      var headers = <String, String>{
        "Accept": "*/*",
        'Content-Type': 'application/json',
      };
      var body = jsonEncode(
          <String, dynamic>{"login": login, "mot_de_passe": password});

      debugPrint("BODY : ${body.toString()}");

      final response = await http.post(Uri.parse("$_baseUrl/connexion"),
          headers: headers, body: body);
      debugPrint("$response");
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
        debugPrint("RESPONSE 200 - OK");
        final data = await jsonDecode(response.body);
        debugPrint(
            "${data["infos"]["utilisateur"]["pseudo"]}\n${data["infos"]["utilisateur"]["isAdmin"]}\n${data["infos"]["utilisateur"]["jwt_token"]}");
        if (data["infos"]["utilisateur"]["isAdmin"] == true) {
          var userData = {
            "pseudo": data["infos"]["utilisateur"]["pseudo"],
            "isAdmin": 1,
            "token": data["infos"]["utilisateur"]["jwt_token"]
          };
          debugPrint("$userData");
          final user = User.fromData(userData);

          debugPrint(user.toString());
          return user;
        } else {
          return User.fromData(
              {"pseudo": data["infos"]["utilisateur"]["pseudo"], "isAdmin": 0});
        }
      } else if (response.statusCode == 404) {
        return User.fromData({"pseudo": "Unknown", "isAdmin": 0});
      } else {
        throw Future.error("ERROR : Something went wrong");
      }
    } catch (error) {
      throw Future.error("ERROR : $error");
    }
  }
}
