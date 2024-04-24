import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/stock_page.dart';
import 'package:maison_des_ligues_drawer/widgets/custom_speeddial.dart';

import '../../models/categorie_model.dart';
import '../../services/boutique_services.dart';

class BoutiqueOverviewPage extends StatefulWidget {
  const BoutiqueOverviewPage({super.key});

  @override
  State<BoutiqueOverviewPage> createState() => _BoutiqueOverviewPageState();
}

class _BoutiqueOverviewPageState extends State<BoutiqueOverviewPage> {
  late Future<List<Categorie>> _listeCategories;
  final storage = const FlutterSecureStorage();

  Future<void> _fetchCategories() async {
    setState(() {
      _listeCategories = BoutiqueServices.getAllCategories();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Boutique"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                textAlign: TextAlign.center,
                "Toute la boutique",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => const StockPage(),
                      arguments: {"categorie_id": "", "nom": ""},
                      // This is how you give transitions.
                      transition: Transition.rightToLeftWithFade,
                      // This is how you can set the duration for navigating the screen.
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  child: const Text("Tous les articles...")),
              const SizedBox(
                height: 20,
              ),
              const Text(
                textAlign: TextAlign.center,
                "Ou alors...",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                textAlign: TextAlign.center,
                "Nos articles par catégories",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                textAlign: TextAlign.center,
                "Poursuivez votre navigation en choisissant une catégorie...",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: FutureBuilder<List>(
                    future: _listeCategories,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                            itemCount: snapshot.data!.length,
                            physics: const BouncingScrollPhysics(
                                decelerationRate: ScrollDecelerationRate.normal,
                                parent: PageScrollPhysics()),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, mainAxisExtent: 80),
                            itemBuilder: (context, index) {
                              final categorie = snapshot.data![index];
                              final nom = categorie.nom;
                              final id = categorie.id;
                              return Card(
                                elevation: 4,
                                child: Center(
                                  child: ListTile(
                                    onTap: () {
                                      Get.to(
                                        () => const StockPage(),
                                        arguments: {
                                          "categorie_id": id,
                                          "nom": nom
                                        },
                                        // This is how you give transitions.
                                        transition:
                                            Transition.rightToLeftWithFade,
                                        // This is how you can set the duration for navigating the screen.
                                        duration:
                                            const Duration(milliseconds: 500),
                                      );
                                    },
                                    title: Text(
                                      nom,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        floatingActionButton: const CustomSpeedDial());
  }
}
