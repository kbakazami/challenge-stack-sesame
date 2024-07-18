import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:nfc_manager/nfc_manager.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.last;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkNFCPermission() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      print('NFC is available.');
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          print('NFC tag found: ${tag.data}');
          NfcManager.instance.stopSession();
          // Ajoutez ici la logique pour traiter les tags NFC
        },
      );
    } else {
      print('NFC is not available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner le QR Code')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0), // Espace en haut
                ElevatedButton(
                  onPressed: _checkNFCPermission,
                  child: const Text('Utiliser le NFC'),
                ),
                const SizedBox(height: 16.0), // Espace entre le bouton et la caméra
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(16.0), // Marges pour créer les bords
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 4.0), // Bordures
                    ),
                    child: CameraPreview(_controller),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
