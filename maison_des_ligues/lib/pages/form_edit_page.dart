import 'package:flutter/material.dart';
import 'package:maison_des_ligues/models/article_model.dart';

class EditArticlePage extends StatefulWidget {
  const EditArticlePage({required Article article, super.key});


  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  @override
  void initState() {
    super.initState();
    debugPrint("InitState() _article (Edit article page");
    // debugPrint(widget.article["id"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Formulaire de modification")
      ),
      body: const Center(child: Text("Modif")),
    );
  }
}
