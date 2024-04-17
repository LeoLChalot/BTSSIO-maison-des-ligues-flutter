// ignore_for_file: use_build_context_synchronously

import "dart:async";

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../models/categorie_model.dart';
import '../../services/boutique_service.dart';

class AjoutArticlePage extends StatefulWidget {
  const AjoutArticlePage({super.key});

  @override
  State<AjoutArticlePage> createState() => _AjoutArticlePageState();
}

class _AjoutArticlePageState extends State<AjoutArticlePage> {
  XFile? _image;

  late Object _newArticle;
  late Future<List<Categorie>> _categories;
  late String selectedCategorieType;

  final GlobalKey<FormState> _addForm = GlobalKey<FormState>();
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

  // Get from gallery / camera
  Future<void> _getFromGallery(context, choice) async {
    debugPrint("in getFromGallery()");
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = choice == "camera"
          ? await picker.pickImage(source: ImageSource.camera)
          : await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = XFile(pickedFile.path);
        });

        debugPrint("_IMAGE => ${_image?.path}");
        Get.back();
      } else {
        debugPrint("pickedFile == null !");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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

    debugPrint("UPLOAD IMAGE => ${_image.toString()}");
    final categorie = await _getCategorie(categorieControllerText);

    setState(() {
      _newArticle = {
        "nom": nomControllerText,
        "description": descriptionControllerText,
        "prix": prixControllerText.toString(),
        "quantite": quantiteControllerText.toString(),
        "categorie_id": categorie.id
      };
    });

    if (await BoutiqueServices.createArticle(_image, _newArticle)) {
      setState(() {
        _nomController.text = "";
        _imageController.text = "";
        _descriptionController.text = "";
        _prixController.text = "";
        _quantiteController.text = "";
        _categorieController.text = "";
        _image = null;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Article ajouté !')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Il semble y avoir eu une erreur...')));
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("InitState() _article (Edit article page)");
    _fetchCategories();
    selectedCategorieType = "413875cb-cbc1-4971-8c72-e2e7e86219bf";
  }

  // Fonction déclancheur
  Future<void> showPictureChoices(context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text(textAlign: TextAlign.center, "Source ?"),
              content: SizedBox(
                  width: 100,
                  height: 100,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () => _getFromGallery(context, "camera"),
                            child: const Icon(Icons.camera_alt)),
                        ElevatedButton(
                            onPressed: () =>
                                _getFromGallery(context, "gallery"),
                            child: const Icon(Icons.image)),
                      ])));
        });
  }

  @override
  Widget build(BuildContext context) => KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection,
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.yellow[600],
            foregroundColor: Colors.red[900],
            centerTitle: true,
            shadowColor: Colors.black,
            elevation: 5,
            title: Text(
                style: TextStyle(
                  color: Colors.red[900],
                  fontWeight: FontWeight.bold,
                ),
                "Formulaire d'ajout"),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: _addForm,
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

                        // Text Area - Description de l'article
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                            controller: _descriptionController,
                            maxLines: 4,
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
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
                                errorText: isANumber
                                    ? null
                                    : "Veuillez saisir un chiffre"),
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
                                final displayedCategories =
                                    categories.take(10).toList();
                                return DropdownButtonFormField<String?>(
                                  items: displayedCategories
                                      .map((categorie) => DropdownMenuItem(
                                            value: categorie.id,
                                            child: Text(categorie.nom),
                                          ))
                                      .toList(),
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder()),
                                  value: selectedCategorieType,
                                  onChanged: (value) async {
                                    selectedCategorieType = value!;
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                    'Error: ${snapshot.error}'); // Handle errors
                              } else {
                                return const CircularProgressIndicator(); // Show loading indicator
                              }
                            },
                          ),
                        ),

                        // Soumission
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // FILE INPUT

                            ElevatedButton.icon(
                              onPressed: () async {
                                showPictureChoices(context);
                              },
                              label: (_image?.name != null)
                                  ? Text("${_image?.name.substring(0, 5)}...")
                                  : const Text("Upload"),
                              icon: const Icon(Icons.photo_camera),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_addForm.currentState!.validate()) {
                onSubmit(context);
              }
            },
            child: const Icon(Icons.add_sharp),
          ),
        ),
      );
}
