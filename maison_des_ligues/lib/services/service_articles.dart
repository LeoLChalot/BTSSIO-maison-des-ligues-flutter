import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleService {
  static Future<List<Article>> getAllArticles() async {
    // Définir l'URL de l'API
    final url = Uri.parse('http://localhost:3000/m2l/boutique/articles');

    // Envoyer la requête GET et analyser la réponse
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Requête réussie, analyser le corps de la réponse
      final data = jsonDecode(response.body) as List;
      // Convertir la liste JSON en une liste d'objets Article
      final articles = data.map((article) => Article.fromJson(article)).toList();
      return articles;
    } else {
      // Erreur de connexion
      print('Erreur de connexion : ${response.statusCode}');
      return [];
    }
  }
}

// Classe Article pour représenter un article
class Article {
  final int id;
  final String nom;
  final String description;
  final double prix;

  Article({required this.id, required this.nom, required this.description, required this.prix});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      nom: json['nom'] as String,
      description: json['description'] as String,
      prix: json['prix'] as double,
    );
  }
}
