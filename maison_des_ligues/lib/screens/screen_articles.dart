import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:maison_des_ligues/providers/articles.dart';
// import 'package:maison_des_ligues/services/service_articles.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final articlesProvider = Provider.of<Articles>(context);
    final articles = articlesProvider.articles;

    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];

          return ListTile(
            title: Text(article.nom),
            subtitle: Text(article.description),
          );
        },
      ),
    );
  }
}
