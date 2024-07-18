import 'package:flutter/cupertino.dart';
import 'package:front/widgets/bathroomCard.dart';

class BathroomsList extends StatelessWidget {
  const BathroomsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const BathroomCard(gridCount: 5, childAspectRatio: 0.4);
  }
}