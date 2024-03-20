import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connexion')),
      body: Column(children: [
        FormLogin(),
        SizedBox(height: 16.0),
        FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/stockItems');
            },
            child: Text('login')),
      ]),
      resizeToAvoidBottomInset: false,
    );
  }
}

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Nom d\'utilisateur'),
              controller: _loginController,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Connexion'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  final username = _loginController.text;
                  final password = _passwordController.text;
                  print(
                      'Connexion de $username avec le mot de passe $password');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
