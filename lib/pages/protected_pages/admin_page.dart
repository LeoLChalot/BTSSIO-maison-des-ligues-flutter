import 'dart:core';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maison_des_ligues_drawer/services/user_service.dart';

import '../../models/user_model.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late final Future<List<User>> _listeUtilisateurs;
  final List<bool> _adminStates = [];
  bool light1 = true;

  Future<void> _fetchUsers() async {
    debugPrint("_fetchUsers()");
    _listeUtilisateurs = UserService.getAllUsers();
  }

  String formatDate(String dateString) {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);
    // Format the date using a specific format
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
    // Return the formatted date
    return formattedDate;
  }

  Future<void> _dialogBuilder(BuildContext context, User user) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final registrationDate = formatDate(user.registrationDate);
        final email = user.email;
        final nom = user.nom;
        final prenom = user.prenom;
        final pseudo = user.pseudo;
        final role = user.isAdmin;

        return AlertDialog(
          title: const Text(textAlign: TextAlign.center, "Infos profil"),
          content: Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
            },
            border: TableBorder.all(color: Colors.black),
            children: [
              TableRow(children: [
                const TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(textAlign: TextAlign.center, "Nom")),
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(textAlign: TextAlign.center, nom)),
              ]),
              TableRow(children: [
                const TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(textAlign: TextAlign.center, "Prénom")),
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(textAlign: TextAlign.center, prenom)),
              ]),
              TableRow(children: [
                const TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(textAlign: TextAlign.center, "Pseudo")),
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(textAlign: TextAlign.center, pseudo)),
              ]),
              TableRow(children: [
                const TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(textAlign: TextAlign.center, "Email")),
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(textAlign: TextAlign.center, email)),
              ]),
              TableRow(children: [
                const TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(textAlign: TextAlign.center, "Rôle")),
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(
                        textAlign: TextAlign.center,
                        role ? "Admin" : "Utilisateur")),
              ]),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Fermer'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _togglePrivilege(String id) async {
    await UserService.togglePrivilege(id);
    setState(() {});
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.verified_user_outlined);
      }
      return const Icon(Icons.account_circle);
    },
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
              "Gestion Admin"),
        ),
        body: FutureBuilder<List>(
          future: _listeUtilisateurs,
          // Your async function that returns Future<YourData>
          builder: (context, snapshot) {
            // debugPrint("_LISTEUTILISATEURS => ${_listeUtilisateurs.toString()}");
            // debugPrint("SNAPSHOT => ${snapshot.toString()}");
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // Handle unexpected data length (optional):
              snapshot.data!.sort((user1, user2) {
                if (user1.isAdmin == user2.isAdmin) {
                  return user1.nom.compareTo(
                      user2.nom); // Sort by name if isAdmin is the same
                } else {
                  return user1.isAdmin ? -1 : 1; // Place admins first
                }
              });
              // debugPrint(snapshot.hasData.toString());
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // debugPrint(snapshot.data![index].toString());
                    final user = snapshot.data![index];
                    final id = user.id.toString();
                    final nom = user.nom;
                    final prenom = user.prenom;
                    final pseudo = user.pseudo;
                    final email = user.email;
                    final registrationDate = formatDate(user.registrationDate);
                    final bool isAdmin = user.isAdmin;
                    _adminStates.add(isAdmin);

                    return Column(
                      children: [
                        Card(
                            child: ColoredBox(
                          color: Colors.green,
                          child: Material(
                            child: SwitchListTile(
                              tileColor: Colors.white,
                              title: Text("$pseudo"),
                              subtitle: Text("Depuis : $registrationDate"),
                              value: _adminStates[index],
                              secondary: (_adminStates[index])
                                  ? const Icon(Icons.verified_user_outlined)
                                  : const Icon(Icons.account_circle),
                              thumbIcon: thumbIcon,
                              onChanged: (bool value) async {
                                if (await confirm(
                                  context,
                                  title: const Text('Confirmation !'),
                                  content: Text(value
                                      ? "Confirmer l'accès au status \"Admin\"?"
                                      : "Confirmer la perte du status \"Admin\"?"),
                                  textOK: const Text('Oui'),
                                  textCancel: const Text('Non'),
                                )) {
                                  _togglePrivilege(id);
                                  setState(() {
                                    _adminStates[index] =
                                        value; // Update state in setState
                                  });
                                }
                              },
                            ),
                          ),
                        )),
                      ],
                    );
                  });
              // Use the data to build your widget
            } else {
              return const Center(child: CircularProgressIndicator());
            } // Show loading ind
          },
        ));
  }
}
