import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maison_des_ligues_drawer/services/auth_service.dart';
import 'package:maison_des_ligues_drawer/utils/navigation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  await Get.putAsync(() => AuthService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Maison des Ligues",
      getPages: appPages,
      initialRoute: Routes.loginPage,
    );
  }
}
