import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../services/user.dart';

class AuthProvider extends ChangeNotifier {

  Future<dynamic> handleSignIn(_googleSignIn, bool isCompany) async {
    try {
      final response = await _googleSignIn.signIn();
      final auth = await response?.authentication;
      final token = auth.accessToken;

      int roleId = 2;

      if(isCompany) {
        roleId = 3;
      }

      final user = await createUser(token, roleId);

      if(user.statusCode == 200){
        final box = await Hive.openBox('customer');
        box.put('token', token);
        return jsonDecode(user.body);
      } else {
        throw Exception('Couldn\'t verify user');
        return null;
      }
    } catch (error) {
      print(error); // ignore: avoid_print
    }
  }

  Future<void> handleSignOut(_googleSignIn) => _googleSignIn.disconnect();
}