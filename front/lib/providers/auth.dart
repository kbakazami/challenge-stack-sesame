import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

  Future<dynamic> handleSignIn(_googleSignIn) async {
    try {
      final response = await _googleSignIn.signIn();
      final auth = await response?.authentication;
      final token = auth.accessToken;
    } catch (error) {
      print(error); // ignore: avoid_print
    }
  }

  Future<void> _handleSignOut(_googleSignIn) => _googleSignIn.disconnect();
}