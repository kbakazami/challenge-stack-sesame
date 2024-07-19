import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:front/constants/colors.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/user.dart';
import '../../providers/auth.dart';
import '../services/user.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Profile extends StatefulWidget {
  final String buttonText;
  final String iconName;

  const Profile(this.buttonText, this.iconName, {super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.get("CLIENT_ID"),
    scopes: ["https://www.googleapis.com/auth/userinfo.profile", "https://www.googleapis.com/auth/user.gender.read", "https://www.googleapis.com/auth/user.birthday.read"],
  );

  deleteAccount(userId) async {
    final response = await deleteUserById(userId);
    if(response == 201) {
     _googleSignIn.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    String iconName = widget.iconName;
    String buttonText = widget.buttonText;
    return Scaffold(
        extendBody: true,
        body: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Builder(builder: (context) {
              if(user != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(user.photoUrl as String),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.username as String,
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    Text(user.email as String),
                    const SizedBox(height: 80),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/icons/$iconName'),
                      label: Text(
                        buttonText,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: () => deleteAccount(user.id),
                      icon: const Icon(Icons.warning, color: Colors.red),
                      label: const Text(
                        'Supprimer mon compte',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: () {_googleSignIn.disconnect(); Navigator.pushNamed(context, 'login'); },
                      icon: const Icon(Icons.logout, color: AppColors.primary),
                      label: const Text(
                        'Se déconnecter',
                        style: TextStyle(color: AppColors.primary),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      ),
                    ),
                  ],
                );
              }
              return const Text("Une erreur est survenue veuillez réessayer.");
            }),
          ),
        )
    );
  }
}
