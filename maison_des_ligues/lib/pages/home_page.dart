// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:maison_des_ligues/pages/dashboard.dart';
import 'package:maison_des_ligues/pages/articles_page.dart';
import 'package:maison_des_ligues/pages/form_ajout_page.dart';

import '../models/article_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  setCurrentIndex(int index) => {setState(() => _currentIndex = index)};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: const [
              Text("Accueil"),
              Text("Articles"),
              Text("Ajout")
            ][_currentIndex]),
        body: [
          const Dashboard(),
          const ArticlesPage(),
          const FormAjoutArticle(),
        ][_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.black38,
          iconSize: 32,
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_sharp), label: "Accueil"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shop_two),
                label: "Articles"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_sharp), label: "Ajout"),
          ],
        ),
      ),
    );
  }
}
