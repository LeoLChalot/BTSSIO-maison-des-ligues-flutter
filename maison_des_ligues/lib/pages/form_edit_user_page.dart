import 'package:flutter/material.dart';
import 'package:maison_des_ligues/widgets/update_user_form.dart';

import '../models/user_model.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({required this.user, super.key});

  final User user;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late final User _user = widget.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_user.prenom)),
        body: UpdateUserForm(user: _user));
  }
}
