import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front/constants/colors.dart';
import 'package:front/models/user.dart';
import 'package:front/providers/auth.dart';
import 'package:front/providers/user.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.get("CLIENT_ID"),
  );

  late Map<String, dynamic> _currentUser;

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = {
          "username" : account?.displayName,
          "email": account?.email,
          "photoUrl": account?.photoUrl,
          "role": "USER"
        };
      });
    });

    _googleSignIn.signInSilently();
  }

  Future<void> login() async {
    await Provider.of<AuthProvider>(context, listen: false).handleSignIn(_googleSignIn);

    if(mounted && _currentUser != null) {
      Provider.of<UserProvider>(context, listen: false).updateUser(User.fromJson(_currentUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
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
              onPressed: () => login(),
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      side: BorderSide(
                          color: AppColors.primary,
                          width: 2
                      ),
                  ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/google.svg', width: 30),
                  const SizedBox(width: 20),
                  const Text("Connexion via google", style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}