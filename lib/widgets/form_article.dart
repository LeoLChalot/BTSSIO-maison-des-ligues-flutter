import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../models/article_model.dart';
import '../models/categorie_model.dart';
import '../services/administration_services.dart';
import '../services/boutique_services.dart';

class FormArticle extends StatefulWidget {
  final Article article;

  const FormArticle({super.key, required this.article});

  @override
  State<FormArticle> createState() => _FormArticleState();
}

class _FormArticleState extends State<FormArticle> {
  late Article _article;
  XFile? _image;

  late Map<String, dynamic> _newArticle;
  late Map<String, dynamic> _updatedArticle;
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
    setState(() {
      _categories = BoutiqueServices.getAllCategories();
    });
  }

  Future<Categorie> _getCategorie(String id) async {
    return BoutiqueServices.getCategorieById(id);
  }

  void setValidator(valid) {
    setState(() {
      isANumber = valid;
    });
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
    setState(() {
      nomControllerText = _nomController.text;
      descriptionControllerText = _descriptionController.text;
      prixControllerText = double.parse(_prixController.text);
      quantiteControllerText = int.parse(_quantiteController.text);
      categorieControllerText = selectedCategorieType;
    });

    debugPrint("UPLOAD IMAGE => ${_image.toString()}");
    final categorie = await _getCategorie(categorieControllerText);

    if (_article.nom == "") {
      setState(() {
        _newArticle = {
          "nom": nomControllerText,
          "description": descriptionControllerText,
          "prix": prixControllerText.toString(),
          "quantite": quantiteControllerText.toString(),
          "categorie_id": categorie.id
        };
      });
      if (await AdministrationServices.createArticle(_image, _newArticle)) {
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
            .showSnackBar(const SnackBar(content: Text('Article ajouté')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Il semble y avoir eu une erreur...')));
      }
    } else {
      setState(() {
        _updatedArticle = {
          "id": _article.id,
          "nom": nomControllerText,
          "description": descriptionControllerText,
          "prix": prixControllerText.toString(),
          "quantite": quantiteControllerText.toString(),
          "categorie_id": categorie.id
        };
      });
      if (await AdministrationServices.updateArticle(_image, _updatedArticle)) {
        setState(() {
          _nomController.text = "";
          _imageController.text = "";
          _descriptionController.text = "";
          _prixController.text = "";
          _quantiteController.text = "";
          _categorieController.text = "";
          _image = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Article mis à jour !')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Il semble y avoir eu une erreur...')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _article = widget.article;
    _fetchCategories();
    if (_article.nom == "") {
      selectedCategorieType = "413875cb-cbc1-4971-8c72-e2e7e86219bf";
    } else {
      _nomController.text = _article.nom;
      _descriptionController.text = _article.description;
      _prixController.text = _article.prix.toString();
      _quantiteController.text = _article.quantite.toString();
      selectedCategorieType = _article.categorie.id;
    }
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
