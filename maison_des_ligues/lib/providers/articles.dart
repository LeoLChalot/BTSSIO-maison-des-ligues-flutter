// articles.dart

import 'package:flutter/material.dart';
import 'package:maison_des_ligues/services/service_articles.dart';

class Articles with ChangeNotifier {
  List<Article> articles = [];

  void setArticles(List<Article> newArticles) {
    articles = newArticles;
    notifyListeners();
  }
}
