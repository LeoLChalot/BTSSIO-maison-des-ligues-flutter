import 'package:flutter/material.dart';
import 'package:maison_des_ligues/models/article_model.dart';
import 'package:maison_des_ligues/widgets/edit_form.dart';

class EditArticlePage extends StatefulWidget {
  const EditArticlePage({required this.article, super.key});

  final Article article;

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  late final Article _article = widget.article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(
          _article.nom
        )),
        body: UpdateForm(article: _article));
  }
}
