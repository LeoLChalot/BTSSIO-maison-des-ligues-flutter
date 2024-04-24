import 'package:flutter/material.dart';

import '../services/administration_services.dart';

class FormCategorie extends StatefulWidget {
  const FormCategorie({super.key});

  @override
  State<FormCategorie> createState() => _FormCategorieState();
}

class _FormCategorieState extends State<FormCategorie> {
  late Future<Map> _result;
  final GlobalKey<FormState> _addForm = GlobalKey<FormState>();
  final _nomController = TextEditingController();

  String nomControllerText = "";

  @override
  void dispose() {
    super.dispose();
    _nomController.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
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
    );
  }
}
