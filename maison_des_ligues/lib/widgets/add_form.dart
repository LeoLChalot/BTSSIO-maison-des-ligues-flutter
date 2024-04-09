import "dart:async";
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maison_des_ligues/pages/home_page.dart';
import 'package:maison_des_ligues/services/boutique_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/categorie_model.dart';

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  XFile? pickedFile;
  late Object _newArticle;
  late Future<List<Categorie>> _categories;
  late String selectedCategorieType;
  late Future<MultipartFile> _image;

  final GlobalKey<FormState> addForm = GlobalKey<FormState>();
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

  Future<void> _fetchCategories() async {
    debugPrint("FT - _fetchCategories()");
    setState(() {
      _categories = BoutiqueServices.getAllCategories();
    });
  }

  Future<Categorie> _getCategorie(String id) async {
    debugPrint("FT - _getCategorie($id)");
    return BoutiqueServices.getCategorieById(id);
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
                    Text("Erreur lors de l'ajout !",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    Text(
                        "Nous avons rencontré un problème lors de l'ajout de l'article !",
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

  _checkedPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera, Permission.storage].request();

    debugPrint("Ask for permission");

    if (statuses[Permission.camera] != PermissionStatus.granted ||
        statuses[Permission.storage] != PermissionStatus.granted) {
      return;
    }

    pickedImage();
  }

  /// Get from gallery
  _getFromGallery(context) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        setState(() {
          _image =
              MultipartFile.fromFile(pickedFile.path, filename: "image.jpg");
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  pickedImage() async {
    final picker = ImagePicker();
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
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

    final categorie = await _getCategorie(categorieControllerText);

    setState(() {
      _newArticle = jsonEncode({
        "nom": nomControllerText,
        "description": descriptionControllerText,
        "prix": prixControllerText.toString(),
        "quantite": quantiteControllerText.toString(),
        "categorie_id": categorie.id
      });
    });

    if (await BoutiqueServices.addArticle(_image, _newArticle)) {
      debugPrint("Article ajouté !");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()));
    } else {
      showWarning();
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("InitState() _article (Edit article page)");
    _fetchCategories();
    selectedCategorieType = "413875cb-cbc1-4971-8c72-e2e7e86219bf";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addForm,
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

              // FILE INPUT
              ElevatedButton(
                onPressed: () {
                  // _checkedPermission();
                  _getFromGallery(context);
                },
                child: const Text("Ajouter une image"),
              ),

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
                    if (addForm.currentState!.validate()) {
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
