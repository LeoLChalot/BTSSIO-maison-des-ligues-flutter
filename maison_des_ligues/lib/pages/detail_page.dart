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
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network("$_baseUrl/${_article.image}"),
            Text(
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
                _article.nom),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${_article.prix} €"),
                Text("${_article.quantite} en stock")
              ],
            )

          ],
        ),
      )),
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
