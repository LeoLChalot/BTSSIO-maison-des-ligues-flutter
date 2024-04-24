import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:maison_des_ligues_drawer/services/administration_services.dart';
import 'package:maison_des_ligues_drawer/services/auth_services.dart';
import 'package:maison_des_ligues_drawer/services/boutique_services.dart';

import '../../utils/navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  final String _userLogin = Get.arguments['userLogin'];
  late Future<Map<String, dynamic>> _commandesStatistiques;
  late Future<Map<String, dynamic>> _articlesStatistiques;

  Future<Map<String, dynamic>> _fetchData() async {
    setState(() {
      _articlesStatistiques = BoutiqueServices.getArticlesStatistiques();
      _commandesStatistiques =
          AdministrationServices.getCommandesStatistiques();
    });
    debugPrint("Commandes : ${_commandesStatistiques.toString()}");
    debugPrint("Articles : ${_articlesStatistiques.toString()}");
    return {
      '_articlesStatistiques': _articlesStatistiques,
      '_commandesStatistiques': _commandesStatistiques,
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
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
            "Overview"),
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
                          "Boutique"),
                      onTap: () {
                        Get.offAndToNamed(
                          Routes.boutiqueOverview,
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: const Icon(size: 35, Icons.admin_panel_settings),
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
                          Get.back();
                          Authentication.logout();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _fetchData(),
              strokeWidth: 3,
              backgroundColor: Colors.yellow[600],
              color: Colors.red[900],
              child: ListView(
                scrollDirection: Axis.vertical,
                // Wrap the cards in a Row
                children: [
                  SizedBox(
                    width: 400,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildStatArticles(
                              articlesData: _articlesStatistiques)
                        ]),
                  ),
                  SizedBox(
                      width: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildStatCommandes(
                              commandesData: _commandesStatistiques),
                        ],
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildStatCommandes(
    {required Future<Map<String, dynamic>> commandesData}) {
  return FutureBuilder<Map<String, dynamic>>(
    future: commandesData,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final data = snapshot.data!;
        final int totalCommandes = data["totalCommandes"];
        final int nombreCommandesSemaineActuelle =
            data["nombreCommandesSemaineActuelle"];
        final int pourcentageProgression =
            data["pourcentage"] ?? (data["pourcentage"] * 100);

        return Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.ssid_chart,
                      size: 24.0,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Activités du site",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                    "Nombre total de commandes : ${totalCommandes.toString()}"),
                Text(
                    "Nombre commandes de la semaine: ${nombreCommandesSemaineActuelle.toString()}"),
                Text(pourcentageProgression > 0
                    ? "+${(nombreCommandesSemaineActuelle * 100).toString()}% par rapport à la dernière semaine"
                    : "${pourcentageProgression.toString()}% par rapport à la dernière semaine"),
              ],
            ),
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return Text('Error: ${snapshot.error}');
      }
    },
  );
}

Widget _buildStatArticles(
    {required Future<Map<String, dynamic>> articlesData}) {
  return FutureBuilder<Map<String, dynamic>>(
    future: articlesData,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final data = snapshot.data!;
        final nombreArticles = data["nombreArticles"];
        final quantiteTotal = data["quantiteTotal"];
        final prixTotal = data["prixTotal"];
        if (data.containsKey("repartition")) {
          final repartition = data["repartition"] as Map;
          final nombreCategories = repartition.length;
          return Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.pie_chart,
                        size: 24.0,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "Répartition des articles par catégorie",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 400.0,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 5,
                                  centerSpaceRadius: 100,
                                  sections: showingSections(
                                      repartition), // Pass data to showingSections function
                                ),
                              ),
                            ),
                          ),
                          // Add Legend widget here
                          const SizedBox(
                              width: 20.0), // Adjust spacing as needed
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Nombre de catégorie : ${nombreCategories.toString()}"),
                      Text(
                          "Nombre de références : ${nombreArticles.toString()}"),
                      Text(
                          "Nombre total d'articles en stock : ${quantiteTotal.toString()}"),
                      Text(
                          "Valeur total des stocks : ${prixTotal.toString()} €"),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      } else {
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return Text('Error: ${snapshot.error}');
      }
    },
  );
}

List<PieChartSectionData> showingSections(final dynamic repartitionCategories) {
  final categories = repartitionCategories
      as Map<String, dynamic>; // Assuming data is in _articlesStatistiques
  double totalValue = 0.0; // Initialize total value to 0.0
  for (final value in categories.values) {
    totalValue += value["valeur"];
  }
  final sections = List.generate(categories.length, (i) {
    final category = categories.keys.toList()[i];
    final value = categories.values.toList()[i];
    final percentage = ((value["valeur"]) / totalValue) * 100;
    return PieChartSectionData(
      color: value["couleur"],
      value: value["valeur"].toDouble(),
      title: '$category\n${percentage.toStringAsFixed(1)}%',
      radius: 50.0,
      titleStyle: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        shadows: [Shadow(color: Colors.black, blurRadius: 2)],
      ),
    );
  });
  return sections;
}
