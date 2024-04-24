import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user_model.dart';
import '../services/user_services.dart';

class UserSwitchTile extends StatefulWidget {
  final User user;

  const UserSwitchTile({super.key, required this.user});

  @override
  State<UserSwitchTile> createState() => _UserSwitchTileState();
}

class _UserSwitchTileState extends State<UserSwitchTile> {
  late User _user;
  late bool _adminState;

  Future<void> _togglePrivilege(String id) async {
    await UserService.togglePrivilege(id);
    setState(() {});
  }

  String formatDate(String dateString) {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);
    // Format the date using a specific format
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    // Return the formatted date
    return formattedDate;
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
    _user = widget.user;
    _adminState = _user.isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = _user.pseudo == "leolchalot" ? true : false;
    return SwitchListTile(
      tileColor: Colors.white,
      title: Text(_user.pseudo),
      subtitle: Text("Depuis : ${formatDate(_user.registrationDate)}"),
      value: _adminState,
      secondary: (_adminState)
          ? const Icon(Icons.verified_user_outlined)
          : const Icon(Icons.account_circle),
      thumbIcon: thumbIcon,
      onChanged: (bool value) async {
        if (!disabled) {
          if (await confirm(
            context,
            title: const Text('Confirmation !'),
            content: Text(_adminState
                ? "Confirmer la perte du status \"Admin\"?"
                : "Confirmer l'accès au status \"Admin\"?"),
            textOK: const Text('Oui'),
            textCancel: const Text('Non'),
          )) {
            _togglePrivilege(_user.id);

            setState(() {
              _adminState = value; // Update state in setState
            });
          }
        }
      },
    );
  }
}
