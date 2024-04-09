// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maison_des_ligues/models/article_model.dart';

import '../widgets/add_form.dart';

class FormAjoutArticle extends StatefulWidget {
  const FormAjoutArticle({super.key});

  @override
  State<FormAjoutArticle> createState() => _FormAjoutArticleState();
}

class _FormAjoutArticleState extends State<FormAjoutArticle> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(child: AddForm()));
  }
}
