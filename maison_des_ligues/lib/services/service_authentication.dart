import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static Future<bool> login(String login, String password) async {
    // Définir l'URL de l'API
    final url = Uri.parse('http://localhost:3000/m2l/user/connexion');

    // Préparer la requête POST
    final body = jsonEncode({'login': login, 'mot_de_passe': password});
    final headers = {'Content-Type': 'application/json'};

    // Envoyer la requête et analyser la réponse
    final response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      // Requête réussie, analyser le corps de la réponse
      final data = jsonDecode(response.body);
      // Traitement des données renvoyées par l'API
      print(data);
      return true;
    } else {
      // Erreur de connexion
      print('Erreur de connexion : ${response.statusCode}');
      return false;
    }
  }
}
