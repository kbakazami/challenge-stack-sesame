import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front/constants/colors.dart';

class Login extends StatelessWidget {

  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Sésame", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary)),
          const SizedBox(height: 40),
          const Image(image: AssetImage('assets/icons/logo.png'), width: 120),
          const SizedBox(height: 40),
          TextButton(
              onPressed: () => print('clicked'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  side: BorderSide(
                    color: AppColors.primary,
                    width: 2
                  )
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/google.svg', width: 30),
                  const SizedBox(width: 20),
                  const Text("Connexion via google", style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                ],
              ),
          )
        ],
      ),
    );
  }
}