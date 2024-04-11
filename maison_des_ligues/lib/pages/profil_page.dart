import 'package:flutter/material.dart';
import 'package:maison_des_ligues/services/user_service.dart';

import '../models/user_model.dart';
import 'form_edit_user_page.dart';
import 'login_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({required this.userPseudo, super.key});

  final String userPseudo;

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late final String _pseudo = widget.userPseudo;
  late final Future<User> _user;

  Future<void> _getUser(String pseudo) async {
    setState(() {
      _user = UserService.getUser(pseudo);
      debugPrint("User => ${_user.toString()}");
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser(_pseudo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<User>(
          future: _user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data!;
              final prenom = user.prenom;
              final nom = user.nom;
              final pseudo = user.pseudo;
              final email = user.email;
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        child: Text(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                            pseudo),
                      ),
                    ),
                    Text(
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        "Prénom: $prenom"),
                    Text(
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        "Nom: $nom"),
                    Text(
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        "Email: $email"),
                    IconButton(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditUserPage(user: user)),
                            ),
                        icon: const Icon(Icons.edit))
                  ]));
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()))
          },
          child: const Icon(Icons.logout),
        ));
  }
}
