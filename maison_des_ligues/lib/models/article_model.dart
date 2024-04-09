import 'package:maison_des_ligues/models/categorie_model.dart';

class Article {
  final String id;
  final String nom;
  final String photo;
  final String description;
  final double prix;
  final int quantite;
  final Categorie categorie;

  Article({
    required this.id,
    required this.nom,
    required this.photo,
    required this.description,
    required this.prix,
    required this.quantite,
    required this.categorie,
  });

  factory Article.fromData(dynamic data) {
    return Article(
        id: data["id"],
        nom: data["nom"],
        photo: data["image"],
        description: data["description"],
        prix: data["prix"],
        quantite: data["quantite"],
        categorie: Categorie.fromData(data["categorie"]));
  }
}
