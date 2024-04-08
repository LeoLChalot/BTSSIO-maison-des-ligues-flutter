// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:maison_des_ligues/pages/home_page.dart';
import 'package:maison_des_ligues/widgets/login_form.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'my_app.dart';
// DotEnv dotenv = DotEnv() is automatically called during import.
// If you want to load multiple dotenv files or name your dotenv object differently, you can do the following and import the singleton into the relavant files:
// DotEnv another_dotenv = DotEnv()

Future main() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => const MyApp(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/dashboard': (context) => const HomePage(),
    },
  ));
}