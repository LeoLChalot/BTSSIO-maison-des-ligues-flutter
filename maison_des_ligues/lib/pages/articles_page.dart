import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maison_des_ligues/models/article_model.dart';
import 'package:maison_des_ligues/pages/detail_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
        future: _articles,
        builder: (context, snapshot) {
          // debugPrint("SCAFFOLD LISTVIEW => ${snapshot.toString()}");
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
                      leading: (image.isNotEmpty)
                          ? Image.network(width: 50, height: 50, image)
                          : const CircularProgressIndicator(),
                      title: Text(nom),
                      subtitle: Text("${prix.toString()} €"),
                      trailing: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DetailPage(article: article)),
                        ),
                      ));
                });
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
