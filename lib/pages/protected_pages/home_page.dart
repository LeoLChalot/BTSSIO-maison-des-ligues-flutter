import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/ajout_article_page.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/ajout_categorie_page.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/stock_page.dart';
import 'package:maison_des_ligues_drawer/services/auth_service.dart';
import 'package:maison_des_ligues_drawer/services/boutique_service.dart';

import '../../models/categorie_model.dart';
import '../../utils/navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _userLogin = Get.arguments['userLogin'];
  late Future<List<Categorie>> _listeCategories;
  final _authService = Get.find<AuthService>();
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
              "Homepage"),
        ),
        drawer: Drawer(
          backgroundColor: Colors.blue[50],
          width: 350,
          elevation: 30,
          shadowColor: Colors.black,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DrawerHeader(
                    child: Center(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                        "Maison des Ligues\nde Lorraine"),
                    Text(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                        "Heureux de vous revoir $_userLogin !"),
                  ],
                ))),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        leading: const Icon(size: 35, Icons.home),
                        title: const Text(
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 5),
                            "Home"),
                        onTap: () {
                          Get.toNamed(Routes.homePage,
                              arguments: {"userLogin": _userLogin});
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        leading: const Icon(size: 35, Icons.storage),
                        title: const Text(
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 5),
                            "Stocks"),
                        onTap: () {
                          Get.offAndToNamed(
                            Routes.stockPage,
                            arguments: {"categorie_id": "", "nom": ""},
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        leading:
                            const Icon(size: 35, Icons.admin_panel_settings),
                        title: const Text(
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 5),
                            "Admin Settings"),
                        onTap: () {
                          Get.offAndToNamed(Routes.adminPage);
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            elevation: 10,
                          ),
                          onPressed: () {
                            _authService
                                .setIsPremium(!_authService.isPremium.value);
                            Get.back();
                            Get.toNamed(Routes.loginPage);
                          },
                          child: const Text(
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              "L O G O U T")),
                    ),
                  ),
                )
              ]),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
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
              const SizedBox(
                height: 30,
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
              /*        SizedBox(
                height: 80,
              )*/
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
            icon: Icons.add_rounded,
            backgroundColor: Colors.yellow[600],
            foregroundColor: Colors.red[600],
            children: [
              SpeedDialChild(
                child:
                    Icon(Icons.add_business_sharp, color: Colors.yellow[600]),
                label: 'Article',
                backgroundColor: Colors.red[600],
                onTap: () {
                  Get.to(
                    const AjoutArticlePage(), transition: Transition.native,
                    // This is how you can set the duration for navigating the screen.
                    duration: const Duration(seconds: 1),
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.category, color: Colors.yellow[600]),
                label: 'Catégorie',
                backgroundColor: Colors.red[600],
                onTap: () {
                  Get.to(
                    const AjoutCategoriePage(), transition: Transition.native,
                    // This is how you can set the duration for navigating the screen.
                    duration: const Duration(seconds: 1),
                  );
                },
              ),
              SpeedDialChild(
                child:
                    Icon(Icons.account_circle_sharp, color: Colors.yellow[600]),
                label: 'Utilisateur',
                backgroundColor: Colors.red[600],
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Vers le formulaire d\'ajout d\'utilisateur')));
                },
              ),
            ]));
  }
}
