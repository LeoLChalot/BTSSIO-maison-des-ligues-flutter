import 'package:flutter/material.dart';
import 'package:maison_des_ligues/widgets/login_form.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text("Maison des ligues de Lorraine")),
      body: const LoginForm(),
    ));
  }
}
