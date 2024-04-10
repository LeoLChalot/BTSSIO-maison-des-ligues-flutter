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
        'Content-Type': 'application/json',
      };
      var body = jsonEncode(
          <String, dynamic>{"login": login, "mot_de_passe": password});

      debugPrint("BODY : ${body.toString()}");

      final response = await http.post(Uri.parse("$_baseUrl/connexion"),
          headers: headers, body: body);
      debugPrint("$response");
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200 &&
          await jsonDecode(response.body)["infos"]["utilisateur"]["isAdmin"] ==
              true) {
        debugPrint("RESPONSE 200 - OK");
        final data = await jsonDecode(response.body);
        var userData = {
          "pseudo": data["infos"]["utilisateur"]["pseudo"],
          "isAdmin": data["infos"]["utilisateur"]["isAdmin"],
          "token": data["infos"]["utilisateur"]["jwt_token"]
        };
        debugPrint("$userData");
        final user = User.fromData(userData);
        return user;
      } else if (response.statusCode == 404) {
        return User.fromData(
            {"pseudo": "Unknown User", "isAdmin": false, "token": "No token"});
      } else {
        throw Future.error("ERROR : Something went wrong");
      }
    } catch (error) {
      throw Future.error("ERROR : $error");
    }
  }
}
