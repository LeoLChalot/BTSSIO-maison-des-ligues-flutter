import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';
import '../models/categorie_model.dart';

class BoutiqueServices {
  static final String _baseUrl = "${dotenv.env['BASE_URL']}/m2l";

  /*
  * Processes the data, and returns a list of Article objects.
  * @returns - A list of Article objects.
  */
  static Future<List<Article>> getAllArticles() async {
    try {
      debugPrint("In getAllArticles() => $_baseUrl/boutique/articles/all");
      final response =
          await http.get(Uri.parse("$_baseUrl/boutique/articles/all"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["infos"]["articles"] as List;
        return data
            .map<Article>((article) => Article.fromData(article))
            .toList();
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data, and returns a list of Category objects.
  * @returns - A list of Categorie objects.
  */
  static Future<List<Categorie>> getAllCategories() async {
    try {
      debugPrint("In getAllCategories() => $_baseUrl/boutique/categories/all");
      final response =
          await http.get(Uri.parse("$_baseUrl/boutique/categories/all"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["infos"]["categories"] as List;
        return data
            .map<Categorie>((categorie) => Categorie.fromData(categorie))
            .toList();
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data, and returns the item targeted by the given [ID]
  * @returns - An Article object.
  */
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

  /*
  * Processes the data, and returns the item targeted by the given [ID]
  * @returns - A Categorie object.
  */
  static Future<Categorie> getCategorieById(String categoryId) async {
    try {
      debugPrint("In getCategorieById() => $categoryId");
      final response = await http
          .get(Uri.parse("$_baseUrl/boutique/categorie/id/$categoryId"));
      if (response.statusCode == 200) {
        final data = await jsonDecode(response.body);
        debugPrint("DATA => ${data["infos"]["categorie"]}");
        return Categorie.fromData(data["infos"]["categorie"]);
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data, and returns the item targeted by the given [name]
  * @returns - An Article object.
  */
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
  * Processes the data, and returns a list of items in the given [category_id]
  * @returns - A list of Article objects.
  */
  static Future<List<Article>> getArticlesByCategory(String categorieId) async {
    try {
      debugPrint("In getArticleByCategory()");
      final response = await http.get(
          Uri.parse("$_baseUrl/boutique/articles/categorie/id/$categorieId"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["infos"]["articles"] as List;
        debugPrint(data.toString());

        return data
            .map<Article>((article) => Article.fromData(article))
            .toList();
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /*
  * Processes the data, and returns a list of items in the given [category_id]
  * @returns - A list of Article objects.
  */
  static Future<Map<String, dynamic>> getArticlesStatistiques() async {
    Color generateColorForCategory(String category) {
      // Use the category name as a seed for the hash function
      final hashCode = category.hashCode;

      // Convert hash value to a range of valid RGB values (0-255)
      final r = (hashCode & 0xFF0000) >> 16;
      final g = (hashCode & 0x00FF00) >> 8;
      final b = hashCode & 0x0000FF;

      // Calculate average brightness (luminosity)
      final avgBrightness = (r + g + b) / 3;

      int adjustColorValue(int colorValue, double avgBrightness,
          {required bool isLighter}) {
        final adjustment = (avgBrightness - 127.5).abs() *
            0.3; // Adjust based on desired lightness preference
        return (isLighter
                ? colorValue + adjustment.toInt()
                : colorValue - adjustment.toInt())
            .clamp(0, 255); // Clamp adjusted value within 0-255 range
      }

      // Adjust colors to prioritize lightness
      final adjustedR = adjustColorValue(r, avgBrightness, isLighter: true);
      final adjustedG = adjustColorValue(g, avgBrightness, isLighter: true);
      final adjustedB = adjustColorValue(b, avgBrightness, isLighter: true);

      // Create a Color object from the adjusted RGB values
      return Color(0xFF000000 | adjustedR << 16 | adjustedG << 8 | adjustedB);
    }

    try {
      final response =
          await http.get(Uri.parse("$_baseUrl/boutique/articles/all"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["infos"]["statistiques"] as Map;
        final categories = data["categories"] as Map<String, dynamic>;
        final coloredCategories = <String, dynamic>{};

        for (final category in categories.keys) {
          final categoryValue = categories[category];
          final color = generateColorForCategory(category);
          debugPrint(color.toString());

          coloredCategories[category] = {
            "libelle": category,
            "valeur": categoryValue,
            "couleur": color, // Convert Color to hex integer for PieChart
          };

          debugPrint(coloredCategories.toString());
        }

        final statistiques = {
          "repartition": coloredCategories,
          "nombreArticles": data["nombreArticles"],
          "quantiteTotal": data["quantiteTotal"],
          "prixTotal": data["prixTotal"],
        };
        return statistiques;
      } else {
        return Future.error("Something went wrong");
      }
    } catch (error) {
      return Future.error(error);
    }
  }
}
