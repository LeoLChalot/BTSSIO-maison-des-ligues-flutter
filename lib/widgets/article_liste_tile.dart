import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/article_model.dart';

class ArticleListTile extends StatelessWidget {
  final Article article;

  const ArticleListTile({super.key, required this.article});
  static final String _baseUrl = "${dotenv.env['BASE_URL']}";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        _dialogBuilder(context, article);
      },
      leading: Image.network("$_baseUrl/${article.image}"),
      title: Text(article.nom),
      subtitle: Text(
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: int.parse(article.quantite) >= 50
                  ? Colors.green
                  : int.parse(article.quantite) >= 10 &&
                          int.parse(article.quantite) < 50
                      ? Colors.yellow[900]
                      : Colors.red[900]),
          '${article.quantite} en stock'),
      trailing: const Icon(Icons.touch_app),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context, Article article) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(textAlign: TextAlign.center, article.nom),
        content: Text(
            textAlign: TextAlign.justify,
            style: const TextStyle(),
            article.description),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
