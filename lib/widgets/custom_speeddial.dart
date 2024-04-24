import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import '../models/article_model.dart';
import '../models/categorie_model.dart';
import '../pages/protected_pages/categorie_page.dart';
import '../pages/protected_pages/article_page.dart';

class CustomSpeedDial extends StatefulWidget {
  const CustomSpeedDial({super.key});

  @override
  State<CustomSpeedDial> createState() => _CustomSpeedDialState();
}

class _CustomSpeedDialState extends State<CustomSpeedDial> {
  final Article _article = Article(
      id: "",
      nom: "",
      image: "",
      description: "",
      prix: "",
      quantite: "",
      categorie: Categorie(id: "", nom: ""));

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        // icon: Icons.add_rounded,
        animatedIcon: AnimatedIcons.home_menu,
        animationAngle: 90,
        // animationDuration: const Duration(milliseconds: 700),
        backgroundColor: Colors.yellow[600],
        foregroundColor: Colors.red[600],
        children: [
          SpeedDialChild(
            child: Icon(Icons.add_business_sharp, color: Colors.yellow[600]),
            label: 'Article',
            backgroundColor: Colors.red[600],
            onTap: () {
              Get.to(
                ArticlePage(article: _article),
                transition: Transition.native,
                // This is how you can set the duration for navigating the screen.
                duration: const Duration(seconds: 1),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.category, color: Colors.yellow[600]),
            label: 'Catégorie',
            backgroundColor: Colors.red[600],
            onTap: () {
              Get.to(
                const CategoriePage(), transition: Transition.native,
                // This is how you can set the duration for navigating the screen.
                duration: const Duration(seconds: 1),
              );
            },
          ),
        ]);
  }
}
