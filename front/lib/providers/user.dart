import 'package:flutter/widgets.dart';
import 'package:front/models/user.dart';
import 'package:flutter/material.dart';
class UserProvider extends ChangeNotifier {
  User? user;

  void updateUser(User userUpdate) {
    user = userUpdate;
    notifyListeners();
  }
}