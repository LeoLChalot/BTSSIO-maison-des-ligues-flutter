class User {
  final String id;
  final String prenom;
  final String nom;
  final String pseudo;
  final String email;
  final bool isAdmin;
  final String registrationDate;
  final String token;

  // Constructor with required fields
  User({
    this.id = '',
    this.prenom = '',
    this.nom = '',
    required this.pseudo,
    this.email = '',
    required this.isAdmin,
    this.registrationDate = '',
    this.token = '',
  });

  factory User.fromData(dynamic data) {
    return User(
      id: data["id"] ?? "",
      prenom: data["prenom"] ?? "",
      nom: data["nom"] ?? "",
      pseudo: data["pseudo"],
      email: data["email"] ?? "",
      isAdmin: data["isAdmin"] == 1,
      registrationDate: data["registrationDate"].toString(),
      token: data["token"] ?? "",
    );
  }
}

class UserLoginException implements Exception {
  final String message;

  UserLoginException({required this.message});
}
