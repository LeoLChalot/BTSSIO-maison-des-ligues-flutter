import 'package:flutter/material.dart';
import 'package:maison_des_ligues/tests/test_model.dart';

class AffichageArticles extends StatefulWidget {
  const AffichageArticles({super.key});

  @override
  State<AffichageArticles> createState() => _AffichageArticlesState();
}

class _AffichageArticlesState extends State<AffichageArticles> {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Liste des articles"),
        ),
        body: FutureBuilder<List>(
          future: _articles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    debugPrint("http://127.0.0.1:3000/${snapshot.data![index]["photo"].toString().replaceAll("\\", "/")}");
                    final image = "http://127.0.0.1:3000/${snapshot.data![index]["photo"].toString().replaceAll("\\", "/")}";
                    final prix = snapshot.data![index]["prix"].toString();
                    final nom = snapshot.data![index]["nom"];
                    return ListTile(
                      leading: Image.network(
                          width: 50,
                          height: 50,
                          image),
                      title: Text(nom),
                      subtitle: Text("$prix €"),
                      trailing: const Icon(Icons.info),
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
