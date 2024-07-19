import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:app_settings/app_settings.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  bool isNFCActive = false;

  @override
  void initState() {
    super.initState();
    // await _checkNFCPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkNFCPermission() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      isNFCActive = true;
    } else {
      isNFCActive = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: const Text('Utilisation de l\'application')),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text("Étape 1 - Choisir vos sanitaires", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, "bathrooms-list"),
                child: const Text('Voir la liste des sanitaires'),
              ),
              const SizedBox(height: 40),
              const Text("Étape 2 - Vérifier que le NFC est activé", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              const SizedBox(height: 10),
              Builder(builder: (context) {
                if(isNFCActive) {
                  return const Text("NFC activé");
                }
                return const Text("NFC Désactivé");
              }),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => AppSettings.openAppSettings(type: AppSettingsType.nfc),
                child: const Text('Activer le NFC'),
              ),
              const SizedBox(height: 40),
              const Text("Étape 3 - Ouvrir la porte", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
              const SizedBox(height: 10),
              const Text('Scanner le boîtier à l\'aide de votre téléphone afin d\'ouvrir la porte du sanitaire.', textAlign: TextAlign.center),
              const SizedBox(height: 40),
              const Text("Étape 4 - Fermer la porte", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
              const SizedBox(height: 10),
              const Text('Scanner le boîtier à l\'aide de votre téléphone à l\'intérieur afin de fermer la porte du sanitaire.', textAlign: TextAlign.center),
              const SizedBox(height: 40),
              const Text("Étape 5 - Quitter le sanitaire", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
              const SizedBox(height: 10),
              const Text('Scanner le boîtier à l\'aide de votre téléphone à l\'intérieur afin d\'ouvrir la porte et quitter le sanitaire.', textAlign: TextAlign.center),
              const SizedBox(height: 40),
            ],
          ),
        ),
      )
    );
  }
}
