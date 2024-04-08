class Article {
  final String id;
  final String nom;
  final String photo;
  final String description;
  final double prix;
  final int quantite;
  final String categorieId;

  Article({
    required this.id,
    required this.nom,
    required this.photo,
    required this.description,
    required this.prix,
    required this.quantite,
    required this.categorieId,
  });

  factory Article.fromData(dynamic data){
    return Article(
      id: data["id"],
      nom: data["nom"],
      photo: data["image"],
      description: data["description"],
      prix: data["prix"],
      quantite: data["quantite"],
      categorieId: data["categorie"]["id"]
    );
  }
}


