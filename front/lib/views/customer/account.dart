import 'dart:ui';

import 'package:flutter/material.dart';

class Account extends StatelessWidget {

  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      child: const Text('Page compte customer'),
    );
  }
}