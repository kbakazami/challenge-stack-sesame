import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user.dart';

class Account extends StatelessWidget {

  static String routeName = '/account';

  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      child: Builder(builder: (context) {
        if(user != null)
          {
            return Column(
              children: [
                Text(user.username as String),
                Text(user.email as String),
                Image.network(user.photoUrl as String),
              ],
            );
          }
        return const Text('Une erreur est survenue, veuillez réessayer dans un moment.');
      }),
    );
  }
}