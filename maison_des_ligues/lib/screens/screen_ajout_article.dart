import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddItemFormScreen extends StatelessWidget {
  const AddItemFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FormAddItem(),
      resizeToAvoidBottomInset: false,
    );
  }
}

class FormAddItem extends StatefulWidget {
  const FormAddItem({super.key});

  @override
  State<FormAddItem> createState() => _FormAddItemState();
}

class _FormAddItemState extends State<FormAddItem> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prixController = TextEditingController();
  final _quantiteController = TextEditingController();
  // final _imageController = FileImage;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameController.dispose();
    _descriptionController.dispose();
    _prixController.dispose();
    _quantiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Nom de l\'article'),
                controller: _nameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                controller: _descriptionController,
              ),
              TextField(
                  decoration: const InputDecoration(labelText: 'Prix'),
                  controller: _prixController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
              TextField(
                  decoration: const InputDecoration(labelText: 'Quantité'),
                  controller: _quantiteController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Connexion'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    final nom = _nameController.text;
                    final description = _descriptionController.text;
                    final prix = _prixController.text;
                    final quantite = _quantiteController.text;

                    print(
                        'Nom : $nom, Description : $description, Prix : $prix, Quantité : $quantite');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
