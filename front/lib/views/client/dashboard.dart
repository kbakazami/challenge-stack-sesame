import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/colors.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  static String routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Text("Dashboard");
  }
}
