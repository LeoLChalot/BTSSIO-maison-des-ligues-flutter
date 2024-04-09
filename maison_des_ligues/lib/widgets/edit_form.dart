import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maison_des_ligues/services/boutique_service.dart';
import "dart:async";

import '../models/article_model.dart';
import '../models/categorie_model.dart';

class UpdateForm extends StatefulWidget {
  const UpdateForm({required this.article, super.key});

  final Article article;

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  late Article _article = widget.article;
  late Article _updatedArticle;
  late Future<List<Categorie>> _categories;
  late Future<Categorie> _categorie;
  late String selectedCategorieType;

  final GlobalKey<FormState> updateForm = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prixController = TextEditingController();
  final _quantiteController = TextEditingController();
  final _categorieController = TextEditingController();

  String nomControllerText = "";
  String imageControllerText = "";
  String descriptionControllerText = "";
  double prixControllerText = 0;
  int quantiteControllerText = 0;
  String categorieControllerText = "";
  RegExp digitValidator = RegExp("[0-9]+");
  bool isANumber = true;

  @override
  void dispose() {
    super.dispose();
    _nomController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _prixController.dispose();
    _quantiteController.dispose();
    _categorieController.dispose();
  }

  @override
  void initState() {
    super.initState();
    debugPrint("InitState() _article (Edit article page)");
    _article = widget.article;
    debugPrint("initState() => INFORMATION DE L'ARTICLE ==> ${_article.toString()}");
    _fetchCategories();
    _nomController.text = _article.nom;
    _descriptionController.text = _article.description;
    _prixController.text = _article.prix.toString();
    _quantiteController.text = _article.quantite.toString();
    _categorie = BoutiqueServices.getCategorieById(_article.categorie.id);
    selectedCategorieType = _article.categorie.id;
  }

  Future<void> _fetchCategories() async {
    debugPrint("FT - _fetchCategories()");
    setState(() {
      _categories = BoutiqueServices.getAllCategories();
    });
  }

  Future<void> _getCategorie(String id) async {
    debugPrint("FT - _getCategorie($id)");
    setState(() {
      _categorie = BoutiqueServices.getCategorieById(id);
    });
  }

  void setValidator(valid) {
    setState(() {
      isANumber = valid;
    });
  }

  Future<void> showWarning() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red, width: 3),
                    color: Colors.lightBlue),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: const Column(
                  children: [
                    Text("Erreur lors de la modification !",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    Text("Une erreur est survenue !",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              Positioned(
                top: -100,
                child: SvgPicture.asset(
                    width: 150,
                    height: 150,
                    "assets/images/svg/warning-error-svgrepo-com.svg"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit(BuildContext context) async {
    debugPrint("FT - onSubmit()");
    setState(() {
      nomControllerText = _nomController.text;
      descriptionControllerText = _descriptionController.text;
      prixControllerText = double.parse(_prixController.text);
      quantiteControllerText = int.parse(_quantiteController.text);
      categorieControllerText = selectedCategorieType;
    });

    _getCategorie(categorieControllerText);
    debugPrint(
        "onSubmit() => INFO OLD CAT ==> ${_article.categorie.id.toString()}");
    
    // debugPrint("onSubmit() => INFO NEW CAT ==> ${_categorie.id.toString()}");

    // Update state with fetched category
    setState(() {
      _updatedArticle = Article.fromData({
        "id": _article.id,
        "nom": nomControllerText,
        "image": _article.photo,
        "description": descriptionControllerText,
        "prix": prixControllerText,
        "quantite": quantiteControllerText,
        "categorie": _categorie
      });
    });

    if (await BoutiqueServices.updateArticle(_updatedArticle)) {
      debugPrint("Article mis à jour !");
      Navigator.of(context).pop();
    } else {
      showWarning();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: updateForm,
      child: Container(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text - Nom de l'article
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    label: Text("Nom"),
                    border: OutlineInputBorder(),
                    hintText: "Nom",
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Veuillez saisir le nom de l'article"
                        : null;
                  },
                ),
              ),

              // FUTURE FILE INPUT
              Container(),

              // Text Area - Description de l'article
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    label: Text("Description"),
                    border: OutlineInputBorder(),
                    hintText: "Description",
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Veuillez saisir la description"
                        : null;
                  },
                ),
              ),

              // Nombre (décimal) - Choix de la quantité
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _prixController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  maxLength: 5,
                  decoration: const InputDecoration(
                    label: Text("Prix"),
                    border: OutlineInputBorder(),
                    hintText: "Prix",
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Veuillez saisir lae prix"
                        : null;
                  },
                ),
              ),

              // Nombre (entier) - Choix de la quantité
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: TextFormField(
                  controller: _quantiteController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  maxLength: 3,
                  onChanged: (inputValue) {
                    if (inputValue.isEmpty ||
                        digitValidator.hasMatch(inputValue)) {
                      setValidator(true);
                    } else {
                      setValidator(false);
                    }
                  },
                  decoration: InputDecoration(
                      label: const Text("Quantité"),
                      border: const OutlineInputBorder(),
                      hintText: "Quantité",
                      errorText:
                          isANumber ? null : "Veuillez saisir un chiffre"),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Veuillez saisir la quantité"
                        : null;
                  },
                ),
              ),

              // DropDown - Choix de la catégorie
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: FutureBuilder<List<Categorie>>(
                  future: _categories, // Access the Future
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final categories = snapshot.data!;
                      final displayedCategories = categories.take(10).toList();
                      return DropdownButtonFormField<String?>(
                        items: displayedCategories
                            .map((categorie) => DropdownMenuItem(
                                  value: categorie.id,
                                  child: Text(categorie.nom),
                                ))
                            .toList(),
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        value: selectedCategorieType,
                        onChanged: (value) async {
                          selectedCategorieType = value!;
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Handle errors
                    } else {
                      return const CircularProgressIndicator(); // Show loading indicator
                    }
                  },
                ),
              ),

              // Soumission
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (updateForm.currentState!.validate()) {
                      onSubmit(context);
                    }
                  },
                  child: const Text("Valider les modifications"),
                ),
              ),
            ]),
      ),
    );
  }
}
