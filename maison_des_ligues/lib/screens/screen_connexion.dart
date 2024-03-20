import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:maison_des_ligues/providers/articles.dart';
// import 'package:maison_des_ligues/screens/screen_articles.dart';
import 'package:maison_des_ligues/services/service_articles.dart';
import 'package:maison_des_ligues/services/service_authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _loginController,
              decoration: const InputDecoration(labelText: 'Login'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre login';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre mot de passe';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  (context) async {
                    // Pass context
                    try {
                      if (_formKey.currentState!.validate()) {
                        // Login logic using AuthService
                        if (await AuthService.login(
                            _loginController.text, _passwordController.text)) {
                          // Login successful, fetch articles
                          print('Login successful');
                          final articles =
                              await ArticleService.getAllArticles();
                          // Update Articles provider using Provider.of
                          Provider.of<Articles>(context, listen: false)
                              .setArticles(articles);
                          // Navigate to articles screen
                          Navigator.pushReplacementNamed(context, '/articles');
                        } else {
                          // Login failed, show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Login ou mot de passe incorrect')),
                          );
                        }
                      }
                    } catch (e) {
                      print(e); // Handle errors
                    }
                  };
                },
                child: const Text('Se connecter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void handleLogin(BuildContext context) async {
  // ... your asynchronous logic here
}
