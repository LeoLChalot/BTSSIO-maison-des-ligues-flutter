import 'package:get/get.dart';
import 'package:maison_des_ligues_drawer/middlewares/protected_routes.dart';
import 'package:maison_des_ligues_drawer/models/article_model.dart';
import 'package:maison_des_ligues_drawer/pages/login_page.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/admin_page.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/ajout_article_page.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/edition_article_page.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/home_page.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/stock_page.dart';

import '../pages/protected_pages/ajout_categorie_page.dart';

abstract class Routes {
  static const loginPage = '/loginpage';
  static const homePage = '/homepage';
  static const stockPage = '/stockpage';
  static const adminPage = '/adminpage';
  static const editionArticlePage = '/editionarticlepage';
  static const ajoutArticlePage = '/ajoutarticlepage';
  static const ajoutCategoriePage = '/ajoutcategoriepage';
  static const ajoutAdminPage = '/ajoutadminpage';
}

final appPages = [
  GetPage(name: Routes.loginPage, page: () => const LoginPage()),
  GetPage(
      name: Routes.homePage,
      page: () => const HomePage(),
      middlewares: [ProtectedRoutes()]),
  GetPage(
      name: Routes.stockPage,
      page: () => const StockPage(),
      middlewares: [ProtectedRoutes()]),
  GetPage(
      name: Routes.adminPage,
      page: () => const AdminPage(),
      middlewares: [ProtectedRoutes()]),
  GetPage(
      name: Routes.editionArticlePage,
      page: () => EditionArticlePage(article: article as Article),
      middlewares: [ProtectedRoutes()]),
  GetPage(
      name: Routes.ajoutArticlePage,
      page: () => const AjoutArticlePage(),
      middlewares: [ProtectedRoutes()]),
  GetPage(
      name: Routes.ajoutCategoriePage,
      page: () => const AjoutCategoriePage(),
      middlewares: [ProtectedRoutes()]),
  GetPage(
      name: Routes.ajoutAdminPage,
      page: () => const AjoutArticlePage(),
      middlewares: [ProtectedRoutes()]),
];

mixin article {}
