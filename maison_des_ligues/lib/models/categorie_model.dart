class Categorie {
  final String id;
  final String nom;

  Categorie({required this.id, required this.nom});

  factory Categorie.fromData(dynamic data) {
    return Categorie(id: data["id"], nom: data["nom"]);
  }
}
