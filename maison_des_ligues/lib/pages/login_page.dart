import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maison_des_ligues/pages/home_page.dart';
import 'package:maison_des_ligues/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final buttonKey = GlobalKey<State>();

  final formLoginController = TextEditingController();
  final formPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    formLoginController.dispose();
    formPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                  width: 250,
                  "assets/images/svg/safe-and-stable-svgrepo-com.svg"),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: formLoginController,
                  decoration: const InputDecoration(
                      label: Text("Login"), border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre identifiant';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: formPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      label: Text("Password"), border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez renseigner votre mot de passe';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: buttonKey,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final login = formLoginController.text;
                      final pass = formPasswordController.text;
                      final userService = UserService();
                      final log = await userService.login(login, pass);
                      if (log["success"] == true && log["isAdmin"] == 1) {
                        final NavigatorState navigator =
                            Navigator.of(buttonKey.currentContext!);
                        navigator.push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const HomePage(),
                        ));
                      } else {
                        return;
                      }
                    }
                  },
                  child: const Text(
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      "Connexion"),
                ),
              )
            ],
          )),
    );
  }
}
