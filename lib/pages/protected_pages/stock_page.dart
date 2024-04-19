import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/edition_article_page.dart';
import 'package:maison_des_ligues_drawer/services/boutique_service.dart';

import '../../models/article_model.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  static final String _baseUrl = "${dotenv.env['BASE_URL']}";

  final String _categorieId = Get.arguments['categorie_id'];
  final bool tri = Get.arguments['categorie_id'] != "" ? true : false;
  final String _nom = Get.arguments['nom'];
  bool _isLoading = false;
  late Future<List<Article>> _listeArticles;

  Future<void> _fetchArticles() async {
    debugPrint("_fetchArticles()");
    _listeArticles = BoutiqueServices.getAllArticles();
    setState(() {});
  }

  Future<void> _fetchArticlesByCategorie(String categorieId) async {
    setState(() {
      _isLoading = true; // Hide loading indicator after data is fetched
    });
    await Future.delayed(const Duration(seconds: 2));
    _listeArticles = BoutiqueServices.getArticleByCategory(_categorieId);
    setState(() {
      _isLoading = false; // Hide loading indicator after data is fetched
    });
    setState(() {});
  }

  void _deleteArticle(String id) async {
    final success = await BoutiqueServices.deleteArticle(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(success ? 'Article supprimé !' : 'Une erreur est survenue...'),
      ),
    );
    if (success) {
      _fetchArticles();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tri ? _fetchArticlesByCategorie(_categorieId) : _fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.yellow[600],
          foregroundColor: Colors.red[900],
          centerTitle: true,
          shadowColor: Colors.black,
          elevation: 5,
          title: Text(
              style: TextStyle(
                color: Colors.red[900],
                fontWeight: FontWeight.bold,
              ),
              _categorieId != ""
                  ? "Catégorie \"$_nom\""
                  : "Gestion des stocks"),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder<List>(
                future: _listeArticles,
                // Your async function that returns Future<YourData>
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          final article = snapshot.data?[index];
                          final image = "$_baseUrl/${article.image}";
                          double.parse(article.prix);
                          final nom = article.nom;
                          final id = article.id;
                          final quantite = article.quantite;
                          return Slidable(
                            // Specify a key if the Slidable is dismissible.
                            key: ValueKey(article),
                            // The start action pane is the one at the left or the top side.
                            startActionPane: ActionPane(
                              // A motion is a widget used to control how the pane animates.
                              motion: const ScrollMotion(),
                              // A pane can dismiss the Slidable.
                              // dismissible: DismissiblePane(onDismissed: () {}),
                              // All actions are defined in the children parameter.
                              children: [
                                // A SlidableAction can have an icon and/or a label.
                                SlidableAction(
                                  onPressed: (context) async {
                                    if (await confirm(
                                      context,
                                      title: const Text(
                                          textAlign: TextAlign.center,
                                          'Attention',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                      content: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text:
                                              "Vous vous apprêtez à supprimer définitivement :\n",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black54),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '\n$nom\n',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const TextSpan(
                                                text:
                                                    '\nCette action est irréversible !',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      /*Text(
                                          "Vous vous apprêtez à supprimer définitivement :\n$nom\nCette action est irréversible !"),*/
                                      textOK: const Text('Confirmer',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      textCancel: const Text('Annuler'),
                                    )) {
                                      _deleteArticle(id);
                                      debugPrint("SlidableAction");
                                      tri
                                          ? _fetchArticlesByCategorie(
                                              _categorieId)
                                          : _fetchArticles();
                                    }
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                                /* SlidableAction(
                            onPressed: (context) =>
                                debugPrint("SlidableAction"),
                            backgroundColor: const Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),*/
                              ],
                            ),
                            // The end action pane is the one at the right or the bottom side.
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  // An action can be bigger than the others.
                                  flex: 1,
                                  onPressed: (context) => {
                                    Get.to(
                                      EditionArticlePage(article: article),
                                      // This is how you give transitions.
                                      transition: Transition.native,
                                      // This is how you can set the duration for navigating the screen.
                                      duration: const Duration(seconds: 1),
                                    )
                                  },
                                  backgroundColor: const Color(0xFF7BC043),
                                  foregroundColor: Colors.white,
                                  icon: Icons.mode_edit_outline,
                                  label: 'Edit',
                                ),
                                /*SlidableAction(
                            onPressed: (context) =>
                                debugPrint("SlidableAction"),
                            backgroundColor: const Color(0xFF0392CF),
                            foregroundColor: Colors.white,
                            icon: Icons.save,
                            label: 'Save',
                          ),*/
                              ],
                            ),
                            // The child of the Slidable is what the user sees when the
                            // component is not dragged.
                            child: Card(
                              child: ListTile(
                                onLongPress: () {
                                  debugPrint("You long press me !");
                                  _dialogBuilder(context, article);
                                },
                                leading: Image.network(image),
                                title: Text(nom),
                                subtitle: Text(
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: int.parse(quantite) >= 50
                                            ? Colors.green
                                            : int.parse(quantite) >= 10 &&
                                                    int.parse(quantite) < 50
                                                ? Colors.yellow[900]
                                                : Colors.red[900]),
                                    '$quantite en stock'),
                                trailing: const Icon(Icons.touch_app),
                              ),
                            ),
                          );
                        });
                    // Use the data to build your widget
                  }
                  return _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Center(
                          child: Text(
                              "Aucun article ne correspond à la recherche..."),
                        ); // Show loading indicator
                },
              ));
  }
}
