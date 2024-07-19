import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../models/bathrooms.dart';
import '../../services/bathrooms.dart';

class BathroomDetail extends StatefulWidget {
  final String argument;

  static String routeName = '/bathroom-detail';

  BathroomDetail(this.argument);

  @override
  _BathroomDetailState createState() => _BathroomDetailState();
}

class _BathroomDetailState extends State<BathroomDetail> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Future<Bathrooms> futureBathroom;

  bool _isAnimationPlaying = true;
  String _buttonText = 'Porte ouverte';

  @override
  void initState() {
    super.initState();
    String id = widget.argument;
    futureBathroom = getBathroomById(id);
    _controller = AnimationController(vsync: this);
    _startResetTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      if (_isAnimationPlaying) {
        _controller.stop();
      } else {
        _controller.forward();
        _startResetTimer();
      }
      _isAnimationPlaying = !_isAnimationPlaying;
    });
  }

  void _startResetTimer() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.reset();
        setState(() {
          _isAnimationPlaying = false;
          _buttonText = 'Porte fermée';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statut d\'un sanitaire'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<Bathrooms> (
              future: futureBathroom,
              builder: (context, snapshot){
                if(snapshot.hasError) {
                  return const Text('Une erreur est survenue, veuillez réessayer.');
                }
                if(!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final bathroom = snapshot.data;
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: _toggleAnimation,
                            child: Lottie.asset(
                              'assets/animations/Animation.json',
                              controller: _controller,
                              onLoaded: (composition) {
                                _controller
                                  ..duration = composition.duration
                                  ..forward();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bathroom!.label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 4),
                              const Text(
                                'Étage 01  Toilette 01',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text('Statut du sanitaire '),
                                  customText(bathroom.state),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _toggleAnimation,
                        icon: Icon(_isAnimationPlaying ? Icons.pause : Icons.play_arrow),
                        label: Text(_buttonText),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(color: Colors.teal),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              }
          )
      ),
    );
  }

  customText(state) {
    switch (state) {
      case 1 :
        return const Text("Occupé");
      case 2 :
        return const Text("Disponible");
      case 3 :
        return const Text("Entretien");
      case 4 :
        return const Text("Maintenance");
      case 5 :
        return const Text("Ouverture");
    }
  }
}