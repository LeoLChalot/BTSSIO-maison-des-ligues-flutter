// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maison_des_ligues/models/article_model.dart';
import 'package:maison_des_ligues/pages/form_ajout_page.dart';
import 'package:maison_des_ligues/pages/form_edit_page.dart';
import 'package:maison_des_ligues/services/boutique_service.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  static final String _baseUrl = "${dotenv.env['BASE_URL']}";
  late Future<List<Article>> _articles;


  @override
  void initState() {
    super.initState();
    _articles = BoutiqueServices.getAllArticles();
  }

  void _refreshArticles() async {
    setState(() {
      _articles = BoutiqueServices.getAllArticles();
    });
  }

  void _deleteArticle(String id) async {
    await BoutiqueServices.deleteArticle(id)
        ? debugPrint("Article Supprimé !")
        : debugPrint("Erreur lors de la suppression!");
    setState(() {
      BoutiqueServices.deleteArticle(id);
      _articles = BoutiqueServices.getAllArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fonction déclancheur
    Future<void> showArticleDetails(Article article) async {
      final id = article.id;
      final image =
          "$_baseUrl/${article.image.toString().replaceAll("\\", "/")}";
      final nom = article.nom;
      final description = article.description;
      final prix = article.prix;
      final quantite = int.parse(article.quantite);

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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            "${prix.toString()} €"),
                        Text(
                            style: TextStyle(
                              color: (quantite > 1) ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            (quantite > 1) ? "$quantite en stock" : "Rupture")
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    _deleteArticle(id);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 24,
                    color: Colors.red,
                  )),
              TextButton(
                child: const Text('Retour'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child:
                    const Text(style: TextStyle(color: Colors.green), 'Editer'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EditArticlePage(article: article)));
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
            debugPrint("SCAFFOLD LISTVIEW => ${snapshot.toString()}");
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final article = snapshot.data?[index];
                    final image =
                        "$_baseUrl/${article.image.toString().replaceAll("\\", "/")}";
                    final prix = article.prix;
                    final nom = article.nom;
                    return ListTile(
                      leading: Image.network(width: 50, height: 50, image),
                      title: Text(nom),
                      subtitle: Text("${prix.toString()} €"),
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
        /*floatingActionButton: FloatingActionButton(
          onPressed: () => {
            debugPrint("Before refresh: $_articles"),
            _refreshArticles(),
            debugPrint("After refresh: $_articles"),
          },
          child: const Icon(Icons.refresh),
        )*/);
  }
}
