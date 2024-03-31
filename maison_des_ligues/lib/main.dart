import 'package:flutter/material.dart';
import 'package:maison_des_ligues/pages/home_page.dart';
import 'package:maison_des_ligues/widgets/login_form.dart';

import 'my_app.dart';

void main() {
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
