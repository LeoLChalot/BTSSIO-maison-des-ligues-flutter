import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/user_model.dart';

class UserPopup extends StatelessWidget {
  final User user;

  const UserPopup({super.key, required this.user});

  String formatDate(String dateString) {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);
    // Format the date using a specific format
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    // Return the formatted date
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Informations'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nom: ${user.nom}'),
          Text('Prénom: ${user.prenom}'),
          Text('Email: ${user.email}'),
          Text('Pseudo: ${user.pseudo}'),
          Text('Rôle: ${user.isAdmin ? 'Admin' : 'Utilisateur'}'),
          Text('Date d\'inscription: ${formatDate(user.registrationDate)}')
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}
