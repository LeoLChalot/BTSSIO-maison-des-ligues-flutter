import 'package:flutter/material.dart';
import "package:maison_des_ligues/models/article_model.dart";
import 'package:maison_des_ligues/services/article_services.dart';

class ArticleProvider extends ChangeNotifier {
  final _service = ArticleService();
  bool isLoading = false;
  List<Article> _articles = [];

  List<Article> get articles => _articles;

  Future<void> getAllArticles() async {
    isLoading = true;
    notifyListeners();
    final response = await _service.getAll();
    _articles = response.cast<Article>();
    isLoading = false;
    notifyListeners();
  }
}
