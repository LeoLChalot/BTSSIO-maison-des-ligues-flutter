import 'dart:convert';

import 'package:http/http.dart' as http;

class UserService {
  Future<dynamic> login(String login, String password) async {
    const String url = "http://10.74.3.0:3000/m2l/user/connexion";
    dynamic body = <String, dynamic>{"login": login, "mot_de_passe": password};
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      var json = await jsonDecode(response.body);
      return json;
    }
    throw "Something went wrong !";
  }
}
