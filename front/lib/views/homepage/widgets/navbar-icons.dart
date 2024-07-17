import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/colors.dart';

class NavbarIcon extends StatelessWidget {

  final double? customIconWidth;
  final int indexItem;
  final int selectedIndexItem;
  final String iconName;
  final Function onItemTapped;

  const NavbarIcon(this.customIconWidth, this.iconName, this.indexItem, this.selectedIndexItem, {super.key, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if(selectedIndexItem == indexItem) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Colors.white,
          ),
          width: 34,
          height: 34,
          child: customIcon(onItemTapped, iconName, AppColors.primary)
        );
      }

      return customIcon(onItemTapped, iconName, Colors.white);
    });
  }

  Widget customIcon(onItemTapped, iconName, iconColor) {

    double iconWidth = customIconWidth ?? 24;

    return IconButton(
        onPressed: () {onItemTapped(indexItem);},
        icon: SvgPicture.asset('assets/icons/$iconName', width: iconWidth , color: iconColor)
    );
  }

}