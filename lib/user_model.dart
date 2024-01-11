// user_model.dart

import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String _userName = '';

  String get userName => _userName;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }
}
