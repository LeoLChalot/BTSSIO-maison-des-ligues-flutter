class User {
  final String pseudo;
  final bool isAdmin;
  final String token;

  User({
    required this.pseudo,
    required this.isAdmin,
    required this.token,
  });

  factory User.fromData(dynamic data) {
    return User(
        pseudo: data["pseudo"], isAdmin: data["isAdmin"], token: data["token"]);
  }

}
