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
    required this.pseudo,
    required this.isAdmin,
    this.id = '',
    this.prenom = '',
    this.nom = '',
    this.email = '',
    this.registrationDate = '',
    this.token = '',
  });

  factory User.fromData(dynamic data) {
    return User(
      pseudo: data['pseudo'],
      isAdmin: data['isAdmin'] == 1 ? true : false,
      id: data['id'] ?? '',
      prenom: data['prenom'] ?? '',
      nom: data['nom'] ?? '',
      email: data['email'] ?? '',
      token: data['token'] ?? '',
    );
  }
}

/*
// Creating a User object with only mandatory fields:
User user1 = User(pseudo: 'john_doe', isAdmin: true);

// Creating a User object with all fields:
User user2 = User(
  id: '123',
  prenom: 'John',
  nom: 'Doe',
  pseudo: 'john_doe',
  email: 'johndoe@example.com',
  registrationDate: '2023-11-21',
  token: 'some_token',
  isAdmin: true,
);

// Creating a User object from a JSON map:
Map<String, dynamic> userData = {
  'id': '456',
  'pseudo': 'jane_smith',
  'email': 'janesmith@example.com',
  // Missing 'isAdmin' field
};
User user3 = User.fromData(userData); // isAdmin will be assigned as false
*/
