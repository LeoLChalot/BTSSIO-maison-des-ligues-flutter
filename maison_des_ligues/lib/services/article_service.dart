import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArticleServices {
  static Future<List<dynamic>> getAllArticles() async {
    const String baseUrl = "http://127.0.0.1:3000/m2l";
    // const String baseUrl = "http://192.168.56.1:3000/m2l";

    try {
      debugPrint("In getAllArticles()");
      // var url = Uri.http("127.0.0.1:3000", "m2l/boutique/articles");

      final response = await http
          .get(Uri.parse("$baseUrl/boutique/articles"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["infos"];
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }
}
