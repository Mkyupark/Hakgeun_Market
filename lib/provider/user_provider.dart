import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false; // 로그인 상태
  String? _userId; // 사용자 UID

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;

  void login(String userId, String password) {
    _isLoggedIn = true;
    _userId = userId;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userId = null;
    notifyListeners();
  }
}
