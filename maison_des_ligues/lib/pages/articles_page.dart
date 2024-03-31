import 'package:flutter/material.dart';
import 'package:maison_des_ligues/models/article_model.dart';
import 'package:maison_des_ligues/pages/form_ajout_page.dart';
import 'package:maison_des_ligues/pages/form_edit_page.dart';
import 'package:maison_des_ligues/services/article_service.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  late Future<List<dynamic>> _articles;

  @override
  void initState() {
    super.initState();
    debugPrint("InitState() _articles");
    _articles = ArticleServices.getAllArticles();
    debugPrint("Contenu de _articles : $_articles");
  }

  void _refreshArticles() async {
    setState(() {
      _articles = ArticleServices.getAllArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fonction déclancheur
    Future<void> showArticleDetails(Article article) async {
      final image =
          "http://127.0.0.1:3000/${article.photo.toString().replaceAll("\\", "/")}";
      final nom = article.nom;
      final description = article.description;
      final prix = article.prix.toString();

      return showDialog<void>(
        /*
        Le context correspond au composant
        dans lequel on souhaite que la popup soit visible
        */
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                const Text(textAlign: TextAlign.center, "Détail de l'article"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Image.network(width: 200, height: 200, image),
                  Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        nom),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 16),
                        description),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        "$prix €"),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete, size: 24, color: Colors.red,)),
              TextButton(
                child: const Text('Retour'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child:
                    const Text(style: TextStyle(color: Colors.red), 'Editer'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                          EditArticlePage(article)));
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        body: FutureBuilder<List>(
          future: _articles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Article> articles = [];

              for (var article in snapshot.data!) {
                articles.add(Article.fromData(article));
              }

              return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    final image =
                        "http://127.0.0.1:3000/${article.photo.toString().replaceAll("\\", "/")}";
                    final prix = article.prix.toString();
                    final nom = article.nom;
                    return ListTile(
                      leading: Image.network(width: 50, height: 50, image),
                      title: Text(nom),
                      subtitle: Text("$prix €"),
                      trailing: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () => showArticleDetails(article),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text("Pas de données"),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            debugPrint("Before refresh: $_articles"),
            _refreshArticles(),
            debugPrint("After refresh: $_articles"),
          },
          child: const Icon(Icons.refresh),
        ));
  }
}
