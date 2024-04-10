import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maison_des_ligues/models/article_model.dart';
import 'package:maison_des_ligues/pages/form_edit_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({required this.article, super.key});

  final Article article;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  static final String _baseUrl = "${dotenv.env['BASE_URL']}";
  late final Article _article = widget.article;
  late final int quantite = int.parse(_article.quantite);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32),
              "Fiche informations")),
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(width: 250, "$_baseUrl/${_article.image}"),
              Text(
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26),
                  _article.nom),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(fontSize: 18),
                                  _article.description)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                              style: const TextStyle(fontSize: 32),
                              "${_article.prix} €"),
                          Text(
                              style: const TextStyle(fontSize: 32),
                              ((quantite) > 0)
                                  ? "${_article.quantite} en stock"
                                  : "Rupture"),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  EditArticlePage(article: _article)),
        ),
        child: Icon(Icons.edit),
      ),
    );
  }
}
