import 'package:flutter/material.dart';
import 'package:maison_des_ligues/screens/screen_connexion.dart';
import 'package:maison_des_ligues/screens/screen_articles.dart';
import 'package:maison_des_ligues/screens/screen_ajout_article.dart';


void main() {
  runApp(const MaterialApp( home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M2L - Dashboard',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        // '/liste-categories': (context) => CategoriesScreen(),
        // '/liste-articles': (context) => ArticlesScreen(),
        '/addItem': (context) => const AddItemFormScreen(),
      },
    );
  }
}
