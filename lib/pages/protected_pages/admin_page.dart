import 'dart:core';

import 'package:flutter/material.dart';
import 'package:maison_des_ligues_drawer/services/administration_services.dart';
import 'package:maison_des_ligues_drawer/widgets/slidable_user.dart';

import '../../models/user_model.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late final Future<List<User>> _listeUtilisateurs;
  final List<bool> _adminStates = [];

  Future<void> _fetchUsers() async {
    _listeUtilisateurs = AdministrationServices.getAllUsers();
  }

  @override
  void initState() {
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
            if (snapshot.hasError) {
              // Handle error (e.g., display an error message)
              debugPrint(snapshot.error.toString());
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            // Users ordered by role
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final response = snapshot.data! as List<User>;
              response.sort((user1, user2) {
                if (user1.isAdmin == user2.isAdmin) {
                  return user1.nom.compareTo(
                      user2.nom); // Sort by name if isAdmin is the same
                } else {
                  return user1.isAdmin ? -1 : 1; // Place admins first
                }
              });
              // debugPrint(snapshot.hasData.toString());
              return ListView.builder(
                  itemCount: response.length,
                  itemBuilder: (context, index) {
                    final user = response[index];
                    _adminStates.add(user.isAdmin);
                    return Column(
                      children: [SlidableUser(user: user)],
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
