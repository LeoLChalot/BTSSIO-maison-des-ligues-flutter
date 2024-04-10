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
      debugPrint("In getAllUsers() => $url");

      var headers = {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Bearer $token"
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["infos"]["users"] as List;
        return data.map<User>((user) => User.fromData(user)).toList();
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
  static Future<bool> deleteArticle(String pseudo) async {
    try {
      final url = "$_baseUrl/user/delete/$pseudo";
      debugPrint("In deleteArticle() => $url");

      final response = await http.delete(Uri.parse(url));
      return (response.statusCode == 200) ? true : false;
    } catch (error) {
      return Future.error(error);
    }
  }
}
