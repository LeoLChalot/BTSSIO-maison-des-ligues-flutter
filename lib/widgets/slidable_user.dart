import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maison_des_ligues_drawer/widgets/user_popup.dart';
import 'package:maison_des_ligues_drawer/widgets/user_switch_tile.dart';
import '../models/user_model.dart';

class SlidableUser extends StatefulWidget {
  final User user;

  const SlidableUser({super.key, required this.user});

  @override
  State<SlidableUser> createState() => _SlidableUserState();
}

class _SlidableUserState extends State<SlidableUser> {
  late User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(_user),
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
                builder: (context) => UserPopup(user: _user),
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
              user: _user,
            ),
          ),
        ),
      ),
    );
  }
}
