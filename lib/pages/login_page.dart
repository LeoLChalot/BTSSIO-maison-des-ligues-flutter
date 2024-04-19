import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/home_page.dart';
import 'package:maison_des_ligues_drawer/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = Get.find<AuthService>();

  // late Future<User> _user;
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
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

  Future<void> onSubmit() async {
    debugPrint("onSubmit()");
    setState(() {
      loginText = loginController.text;
      passwordText = passwordController.text;
    });
    final user = await Authentication.signin(loginText, passwordText);
    debugPrint("USER.ISADMIN => ${user.isAdmin}");
    debugPrint("USER.PSEUDO => ${user.pseudo.toString()}");
    if (user.isAdmin == true) {
      _authService.setIsPremium(true);
      Get.to(
        const HomePage(),
        arguments: {"userLogin": user.pseudo.toString()},
        // This is how you give transitions.
        transition: Transition.native,
        // This is how you can set the duration for navigating the screen.
        duration: const Duration(seconds: 1),
      );

/*      Get.toNamed(Routes.homePage,
          arguments: {"userLogin": user.pseudo.toString()});*/
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.yellow[600],
        foregroundColor: Colors.red[900],
        centerTitle: true,
        shadowColor: Colors.black,
        elevation: 5,
        leading: const SizedBox(),
        title: Text(
            style: TextStyle(
              color: Colors.red[900],
              fontWeight: FontWeight.bold,
            ),
            "Maison des Ligues"),
      ),
      body: Form(
        key: _loginForm,
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
                      label: Text("Pseudo"),
                      border: OutlineInputBorder(),
                      hintText: "Pseudo",
                    ),
                    validator: (value) {
                      return (value == null || value.isEmpty)
                          ? "Veuillez saisir votre Pseudo"
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
                    onPressed: onSubmit,
                    child: const Text("Connexion"),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

/*
 return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome to my awesome App!',
              ),
              const SizedBox(
                height: 16.0,
              ),
              Obx(() {
                return SwitchListTile(
                  title:
                      Text('isPremium value : ${_authService.isPremium.value}'),
                  value: _authService.isPremium.value,
                  onChanged: _authService.setIsPremium,
                );
              }),
              ElevatedButton(
                onPressed: () {
                  Get.offAndToNamed(Routes.homePage);
                },
                child: const Text('GO TO HOME PAGE'),
              ),
            ]),
      ),
    );
 */
