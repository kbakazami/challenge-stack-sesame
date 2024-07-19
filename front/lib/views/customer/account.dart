import 'package:flutter/material.dart';
import 'package:front/widgets/profile.dart';

class Account extends StatelessWidget {

  static String routeName = '/account';

  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return const Profile('Contacter l\'administration', 'phone.svg');
  }
}
