import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_des_ligues/pages/articles_page.dart';
import 'package:maison_des_ligues/pages/form_ajout_page.dart';
import 'package:maison_des_ligues/pages/profil_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _pseudo;
  int _currentIndex = 0;

  setCurrentIndex(int index) => {setState(() => _currentIndex = index)};

  void getPseudo() async {
    const storage = FlutterSecureStorage();
    String? pseudo = await storage.read(key: "pseudo");
    setState(() {
      _pseudo = pseudo!;
    });
  }

  @override
  void initState() {
    super.initState();
    getPseudo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: const [
          Text("Articles"),
          Text("Mon Profil"),
          Text("Ajout")
        ][_currentIndex]),
        body: [
          const ArticlesPage(),
          ProfilPage(userPseudo: _pseudo),
          const FormAjoutArticle(),
        ][_currentIndex],
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const FormAjoutArticle()),
                ),
            child: const Icon(Icons.add)),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.black38,
          iconSize: 32,
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.shop_two), label: "Articles"),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle), label: "Mon Profil"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_sharp), label: "Ajout"),
          ],
        ),
      ),
    );
  }
}
