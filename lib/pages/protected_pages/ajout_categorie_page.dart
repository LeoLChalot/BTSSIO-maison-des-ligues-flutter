// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:maison_des_ligues_drawer/services/administration_services.dart';

import '../../services/boutique_services.dart';

class AjoutCategoriePage extends StatefulWidget {
  const AjoutCategoriePage({super.key});

  @override
  State<AjoutCategoriePage> createState() => _AjoutCategoriePageState();
}

class _AjoutCategoriePageState extends State<AjoutCategoriePage> {
  late Future<Map> _result;
  final GlobalKey<FormState> _addForm = GlobalKey<FormState>();
  final _nomController = TextEditingController();

  String nomControllerText = "";

  @override
  void dispose() {
    super.dispose();
    _nomController.dispose();
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
                    Text("Erreur lors de l'ajout !",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    Text(
                        "Nous avons rencontré un problème lors de l'ajout de l'article !",
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
    });
    setState(() {
      _result = AdministrationServices.createCategorie(nomControllerText);
      _nomController.text = "";
    });
    final data = await _result;

    if (data["status"] == 200 || data["status"] == 404) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data["message"])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Une erreur est survenue...')));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => KeyboardDismisser(
          gestures: const [
            GestureType.onTap,
            GestureType.onPanUpdateDownDirection,
          ],
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.yellow[600],
              foregroundColor: Colors.red[900],
              centerTitle: true,
              shadowColor: Colors.black,
              elevation: 5,
              title: Text(
                  style: TextStyle(
                    color: Colors.red[900],
                    fontWeight: FontWeight.bold,
                  ),
                  "Formulaire d'ajout"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    "Quelle catégorie ?"),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: _addForm,
                  child: Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Text - Nom de la catégorie
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
                                  ? "Veuillez saisir le nom de l'article"
                                  : null;
                            },
                          ),
                        ),

                        FloatingActionButton(
                          onPressed: () {
                            if (_addForm.currentState!.validate()) {
                              onSubmit(context);
                            }
                          },
                          child: const Icon(Icons.add_sharp),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
}
