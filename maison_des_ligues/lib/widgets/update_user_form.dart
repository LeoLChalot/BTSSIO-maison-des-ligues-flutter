import "dart:async";

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maison_des_ligues/pages/home_page.dart';
import 'package:maison_des_ligues/services/boutique_service.dart';
import 'package:maison_des_ligues/services/user_service.dart';

import '../models/user_model.dart';

class UpdateUserForm extends StatefulWidget {
  const UpdateUserForm({required this.user, super.key});

  final User user;

  @override
  State<UpdateUserForm> createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUserForm> {
  late User user = widget.user;
  late User _user;
  late Object _updatedUser;

  final GlobalKey<FormState> updateForm = GlobalKey<FormState>();
  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _pseudoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  String prenomControllerText = "";
  String nomControllerText = "";
  String pseudoControllerText = "";
  String emailControllerText = "";
  String passControllerText = "";

  @override
  void dispose() {
    super.dispose();
    _prenomController.dispose();
    _nomController.dispose();
    _pseudoController.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  Future<void> showWarning() {
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
                    Text("Erreur lors de la modification !",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    Text("Une erreur est survenue !",
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
    debugPrint("FT - onSubmit()");
    setState(() {
      nomControllerText = _nomController.text;
      prenomControllerText = _prenomController.text;
      pseudoControllerText = _pseudoController.text;
      emailControllerText = _emailController.text;
      passControllerText = _passController.text;
    });

    setState(() {
      _updatedUser = {
        "id": user.id,
        "nom": nomControllerText,
        "prenom": prenomControllerText,
        "pseudo": pseudoControllerText,
        "email": emailControllerText,
        "mot_de_passe": passControllerText
      };
    });

    debugPrint(_updatedUser.toString());

    if (await UserService.updateUser(_updatedUser)) {
      const storage = FlutterSecureStorage();
      await storage.write(key: "pseudo", value: _pseudoController.text);
      setState(() {
        _prenomController.text = "";
        _nomController.text = "";
        _pseudoController.text = "";
        _emailController.text = "";
        _passController.text = "";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Utilisateur mis à jour !'),
          action: SnackBarAction(
            label: 'Impec !',
            onPressed: () {},
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Oops, il y a eu une erreur... !'),
        action: SnackBarAction(
          label: 'Retenter...',
          onPressed: () {},
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("InitState() _article (Edit article page)");
    _user = widget.user;
    _prenomController.text = _user.prenom;
    _nomController.text = _user.nom;
    _pseudoController.text = _user.pseudo;
    _emailController.text = _user.email;
  }

  void _deleteArticle(String id) async {
    await BoutiqueServices.deleteArticle(id)
        ? debugPrint("Article Supprimé !")
        : debugPrint("Erreur lors de la suppression!");
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        // padding: EdgeInsets.all(20.0),
        child: Form(
      key: updateForm,
      child: Container(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              // Text - Nom de l'article
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _prenomController,
                  decoration: const InputDecoration(
                    label: Text("Prénom"),
                    border: OutlineInputBorder(),
                    hintText: "Prénom",
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Veuillez saisir votre prénom"
                        : null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    label: Text("Nom"),
                    border: OutlineInputBorder(),
                    hintText: "Nom",
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Veuillez saisir votre nom"
                        : null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _pseudoController,
                  decoration: const InputDecoration(
                    label: Text("Pseudo"),
                    border: OutlineInputBorder(),
                    hintText: "Pseudo",
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Veuillez saisir votre pseudo"
                        : null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    border: OutlineInputBorder(),
                    hintText: "Email",
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Veuillez saisir votre email"
                        : null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text("Mot de passe"),
                    border: OutlineInputBorder(),
                    hintText: "MDP",
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Veuillez saisir votre mdp"
                        : null;
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      if (updateForm.currentState!.validate()) {
                        onSubmit(context);
                      }
                    },
                    child: const Icon(Icons.add_sharp),
                  ),
                ],
              ),
            ]),
      ),
    ));
  }
}
