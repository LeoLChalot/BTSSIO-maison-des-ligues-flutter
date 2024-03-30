/*
import 'dart:convert';

import 'package:http/http.dart' as http;


class Authentication {

  final String login;
  final String password;

  Authentication({
    required this.login,
    required this.password
  })

  void signin() async {
    var res = await http.post(
        Uri.https(
            "localhost:3000",
            "/m2l/user/connexion",
            {
              "login": login,
              "mot_de_passe": password
            }
        ));
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      print(jsonData);
    }
    return null;
  }

}

*/
