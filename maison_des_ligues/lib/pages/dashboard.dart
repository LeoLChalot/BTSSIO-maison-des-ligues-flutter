import 'package:flutter/material.dart';
import 'package:maison_des_ligues/pages/login_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Center(child: Text("Home Page")),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.of(context).pop()
          },
          child: const Icon(Icons.logout),
        ));
  }
}
