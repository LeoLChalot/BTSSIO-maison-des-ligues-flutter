class User {
  final String id;
  final String pseudo;
  final String firstName;
  final String lastName;
  final String email;
  final bool isAdmin;

  User({
    required this.id,
    required this.pseudo,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isAdmin,
  });

  factory User.fromData(dynamic data) {
    return User(
      id: data["id"],
      pseudo: data["pseudo"],
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
      isAdmin: data["isAdmin"],
    );
  }
}
