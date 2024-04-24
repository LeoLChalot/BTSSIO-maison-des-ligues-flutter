// ignore_for_file: use_build_context_synchronously

import "dart:async";

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:maison_des_ligues_drawer/services/administration_services.dart';

import '../../models/article_model.dart';
import '../../models/categorie_model.dart';
import '../../services/boutique_services.dart';
import '../../widgets/form_article.dart';

class AjoutFormPage extends StatefulWidget {
  const AjoutFormPage({super.key, required Article article});

  @override
  State<AjoutFormPage> createState() => _AjoutFormPagePageState();
}

class _AjoutFormPagePageState extends State<AjoutFormPage> {
  @override
  Widget build(BuildContext context) => KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection,
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                FormArticle(
                  article: Article(
                      id: "",
                      nom: "",
                      image: "",
                      description: "",
                      prix: "",
                      quantite: "",
                      categorie: Categorie(id: "", nom: "")),
                )
              ],
            ),
          ),
        ),
      );
}
