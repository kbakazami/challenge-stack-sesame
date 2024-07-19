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
  static String routeName = '/login';

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.get("CLIENT_ID"),
    scopes: ["https://www.googleapis.com/auth/userinfo.profile", "https://www.googleapis.com/auth/user.gender.read", "https://www.googleapis.com/auth/user.birthday.read"],
  );

  late Map<String, dynamic> _currentUser;
  bool isCompany = false;

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = {
          "username" : account?.displayName,
          "email": account?.email,
          "photoUrl": account?.photoUrl,
          "role": ""
        };
      });
    });

    _googleSignIn.signInSilently();
  }

  Future<void> login(bool isCompany) async {
    final response = await Provider.of<AuthProvider>(context, listen: false).handleSignIn(_googleSignIn, isCompany);

    if(mounted && _currentUser != null && response != null) {
      _currentUser['role'] = checkRole(int.parse(response));
      Provider.of<UserProvider>(context, listen: false).updateUser(User.fromJson(_currentUser));
    }
  }

  checkRole(int idRole) {
    switch (idRole) {
      case 1:
      case 3:
        return "ADMIN";
      case 2:
        return "USER";
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
              onPressed: () => login(isCompany),
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
            SizedBox(height: 10),
            checkbox('Je suis une entreprise', isCompany, (state) => setState(() => isCompany = state)),
          ],
        ),
      ),
    );
  }

  Widget checkbox(String title, bool initValue, Function(bool boolValue) onChanged) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(value: initValue, onChanged: (b) => onChanged(b!)),
          Text(title),
        ]);
  }
}