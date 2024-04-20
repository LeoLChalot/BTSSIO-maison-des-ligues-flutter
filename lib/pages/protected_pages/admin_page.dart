import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maison_des_ligues_drawer/services/user_service.dart';
import 'package:maison_des_ligues_drawer/widgets/user_popup.dart';
import 'package:maison_des_ligues_drawer/widgets/user_switch_tile.dart';
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
          builder: (context, snapshot) {
            // debugPrint("_LISTEUTILISATEURS => ${_listeUtilisateurs.toString()}");
            // debugPrint("SNAPSHOT => ${snapshot.toString()}");
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                    _adminStates.add(user.isAdmin);
                    return Column(
                      children: [
                        Slidable(
                          key: ValueKey(user),
                          startActionPane: ActionPane(
                            // A motion is a widget used to control how the pane animates.
                            motion: const ScrollMotion(),
                            // A pane can dismiss the Slidable.
                            // dismissible: DismissiblePane(onDismissed: () {}),
                            // All actions are defined in the children parameter.
                            children: [
                              // A SlidableAction can have an icon and/or a label.
                              SlidableAction(
                                onPressed: (context) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => UserPopup(user: user),
                                  );
                                },
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.info_outline,
                                label: 'Infos',
                              ),
                            ],
                          ),
                          child: Card(
                            child: ColoredBox(
                              color: Colors.green,
                              child: Material(
                                child: UserSwitchTile(
                                    user: user,
                                    adminState: _adminStates[index]),
                              ),
                            ),
                          ),
                        ),
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
