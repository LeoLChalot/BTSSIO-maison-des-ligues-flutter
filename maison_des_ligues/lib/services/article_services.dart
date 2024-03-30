import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maison_des_ligues/models/article_model.dart';

class ArticleService {
  Future<List<Set<Article>>> getAll() async {
    const url = "http://localhost:3000/m2l/boutique/articles";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      final articles = json
          .map((e) => {
                Article(
                    id: e["id"],
                    nom: e["nom"],
                    photo: e["photo"],
                    description: e["description"],
                    prix: e["prix"],
                    quantite: e["quantite"],
                    categorieId: e["categorie_id"])
              })
          .toList();
      return articles;
    }
    throw "Something went wrong";
  }
}
