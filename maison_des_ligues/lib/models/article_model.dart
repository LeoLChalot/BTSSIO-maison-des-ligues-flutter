import 'package:maison_des_ligues/models/categorie_model.dart';

class Article {
  final String id;
  final String nom;
  final String image;
  final String description;
  final String prix;
  final String quantite;
  final Categorie categorie;

  Article({
    required this.id,
    required this.nom,
    required this.image,
    required this.description,
    required this.prix,
    required this.quantite,
    required this.categorie,
  });

  factory Article.fromData(dynamic data) {
    return Article(
        id: data["id"],
        nom: data["nom"],
        image: data["image"].toString().replaceAll("\\", "/"),
        description: data["description"],
        prix: data["prix"].toString(),
        quantite: data["quantite"].toString(),
        categorie: Categorie.fromData(data["categorie"]));
  }
}
