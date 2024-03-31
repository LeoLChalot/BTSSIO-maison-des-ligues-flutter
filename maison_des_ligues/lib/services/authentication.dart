import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authentication {
  static Future<bool> signin(String login, String password) async {
    const String baseUrl = "http://127.0.0.1:3000/m2l";
    // const String baseUrl = "http://192.168.56.1:3000/m2l";
    try {
      debugPrint("In signin()");
      // var url = Uri.http("127.0.0.1:3000", "m2l/boutique/articles");

      var headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };


      var body = jsonEncode(
          <String, dynamic>{"login": login, "mot_de_passe": password});

      final response = await http.post(Uri.parse("$baseUrl/user/connexion"),
          headers: headers, body: body);
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint(data["isAdmin"].toString());
        return (data["isAdmin"].toString() == "1") ? true : false;
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error("ERROR : $error");
    }
  }
}
