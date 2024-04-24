import 'package:get/get.dart';
import 'package:maison_des_ligues_drawer/middlewares/protected_routes.dart';
import 'package:maison_des_ligues_drawer/models/article_model.dart';
import 'package:maison_des_ligues_drawer/pages/login_page.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/admin_page.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/ajout_article_page.dart';
import 'package:maison_des_ligues_drawer/pages/protected_pages/boutique_overview_page.dart';
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
  static const articleFormPage = '/articleformpage';
  static const ajoutCategoriePage = '/ajoutcategoriepage';
  static const ajoutAdminPage = '/ajoutadminpage';
  static const boutiqueOverview = '/boutiqueoverview';
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
      name: Routes.articleFormPage,
      page: () => AjoutFormPage(article: article as Article),
      middlewares: [ProtectedRoutes()]),
/*  GetPage(
      name: Routes.AjoutFormPage,
      page: () => const AjoutFormPage(),
      middlewares: [ProtectedRoutes()]),
*/
  GetPage(
      name: Routes.ajoutCategoriePage,
      page: () => const AjoutCategoriePage(),
      middlewares: [ProtectedRoutes()]),
/*  GetPage(
      name: Routes.ajoutAdminPage,
      page: () => const AjoutArticlePage(),
      middlewares: [ProtectedRoutes()]),

 */
  GetPage(
      name: Routes.boutiqueOverview,
      page: () => const BoutiqueOverviewPage(),
      middlewares: [ProtectedRoutes()]),
];

mixin article {}
