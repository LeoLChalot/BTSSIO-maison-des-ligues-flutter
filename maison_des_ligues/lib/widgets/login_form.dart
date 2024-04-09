import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maison_des_ligues/pages/home_page.dart';
import 'package:maison_des_ligues/services/authentication.dart';

import '../models/user_model.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> login = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  String loginText = "";
  String passwordText = "";

  Future<void> _showWarning() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red, width: 3),
                    color: Colors.lightBlue),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: const Column(
                  children: [
                    Text("Erreur lors de la connexion !",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    Text("Veuillez vérifier vos identifiants, et réessayer",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              Positioned(
                top: -100,
                child: SvgPicture.asset(
                    width: 150,
                    height: 150,
                    "assets/images/svg/warning-error-svgrepo-com.svg"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit(BuildContext context) async {
    setState(() {
      loginText = loginController.text;
      passwordText = passwordController.text;
    });
    final User user = await Authentication.signin(loginText, passwordText);

    if (user.isAdmin == true) {
      // Create storage
      const storage = FlutterSecureStorage();
      // Write value
      await storage.write(key: "access_token", value: user.token);
      debugPrint("Token sauvegardé !");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      _showWarning();
    }
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: login,
      child: Container(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: TextFormField(
                  controller: loginController,
                  decoration: const InputDecoration(
                    label: Text("Login"),
                    border: OutlineInputBorder(),
                    hintText: "Login",
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Veuillez saisir votre login"
                        : null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    label: Text("Password"),
                    border: OutlineInputBorder(),
                    hintText: "Password",
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Veuillez saisir votre mot de passe"
                        : null;
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (login.currentState!.validate()) {
                      onSubmit(context);
                    }
                  },
                  child: const Text("Valider"),
                ),
              ),
            ]),
      ),
    );
  }
}
