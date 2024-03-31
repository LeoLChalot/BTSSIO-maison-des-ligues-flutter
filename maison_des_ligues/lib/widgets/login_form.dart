import 'package:flutter/material.dart';
import 'package:maison_des_ligues/pages/home_page.dart';
import 'package:maison_des_ligues/services/authentication.dart';

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

  Future<void> onSubmit(BuildContext context) async {
    setState(() {
      loginText = loginController.text;
      passwordText = passwordController.text;
    });
    var isAdmin = await Authentication.signin(loginText, passwordText);
    if(isAdmin){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => const HomePage())
      );
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
                  onPressed: () async {
                    if (login.currentState!.validate()) {
                      onSubmit(context);
                    }
                  },
                  child: const Text("Valider"),
                ),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.black54),
                            text: "Login : "),
                        TextSpan(
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.grey),
                            text: loginText),
                      ])),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.black54),
                            text: "Password : "),
                        TextSpan(
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.grey),
                            text: passwordText),
                      ])),
                    ),
                  ]),
            ]),
      ),
    );
  }
}
