import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maison_des_ligues_drawer/widgets/form_article.dart';

import '../../models/article_model.dart';

class ArticlePage extends StatefulWidget {
  final Article article;

  const ArticlePage({super.key, required this.article});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late final Article _article = widget.article;

  @override
  Widget build(BuildContext context) {
    return FormArticle(article: _article);
  }
}
