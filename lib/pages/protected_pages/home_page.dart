import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:maison_des_ligues_drawer/services/auth_service.dart';

import '../../utils/navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = Get.find<AuthService>();
  final String _userLogin = Get.arguments['userLogin'];
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title and subtitle
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Statistiques du site',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20.0),
            Flexible(
              child: ListView(scrollDirection: Axis.horizontal, children: [
                _buildStatCard(
                  title: 'Références d\'articles',
                  value: '1234', // Replace with actual data
                  icon: Icons.book,
                ),
                _buildStatCard(
                  title: 'Nombre total d\'articles en stock',
                  value: '5678', // Replace with actual data
                  icon: Icons.inventory,
                ),
                _buildStatCard(
                  title: 'Coût total des stocks',
                  value: '\$12,345.67', // Replace with actual data
                  icon: Icons.attach_money,
                ),
                _buildStatCard(
                  title: 'Commandes de la semaine',
                  subtitle: 'This Week vs. Last Week',
                  value: '123 (+10%)', // Replace with actual data
                  icon: Icons.shopping_cart,
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildStatCard({
  required String title,
  required String value,
  String? subtitle,
  IconData? icon,
}) {
  return Card(
    elevation: 4.0,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 24.0,
                color: Colors.blue,
              ),
              const SizedBox(width: 10.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) const SizedBox(height: 10.0),
          if (subtitle != null)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    ),
  );
}
