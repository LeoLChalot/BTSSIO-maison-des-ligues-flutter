import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/article_model.dart';

class ArticleServices {
  static final String _baseUrl = "${dotenv.env['BASE_URL']}/m2l";

  // A function that retrieves all articles from the boutique API and returns them as a list of Article objects.
  // processes the data, and returns a list of Article objects.
  static Future<List<Article>> getAllArticles() async {
    try {
      debugPrint("In getAllArticles() => $_baseUrl/boutique/articles/all");
      final response =
          await http.get(Uri.parse("$_baseUrl/boutique/articles/all"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["infos"]["articles"] as List;
        return data
            .map<Article>((articleData) => Article.fromData(articleData))
            .toList();
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  static Future<List<Article>> getArticleByCategory(String categorieId) async {
    try {
      debugPrint("In getArticleByCategory()");
      final response = await http.get(
          Uri.parse("$_baseUrl/boutique/articles/categorie/id/$categorieId"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["infos"]["articles"] as List;
        return data
            .map<Article>((articleData) => Article.fromData(articleData))
            .toList();
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

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
  * Uniquement utilisable par l'administrateur,
  * à l'aide du token fourni dans le Headers
  *
  * Using [id] to search the product
  * @return
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
}
