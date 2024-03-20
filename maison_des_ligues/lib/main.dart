import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:maison_des_ligues/providers/articles.dart';
import 'package:maison_des_ligues/screens/screen_connexion.dart';
import 'package:maison_des_ligues/screens/screen_articles.dart';
import 'package:maison_des_ligues/screens/screen_ajout_article.dart';


void main() {
  runApp(
    ChangeNotifierProvider<Articles>(
      create: (context) => Articles(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M2L - Dashboard',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/articles': (context) => const ArticlesPage(),
      },
    );
  }
}

