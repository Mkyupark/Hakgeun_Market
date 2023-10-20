import 'package:flutter/material.dart';

// 페이지 이동을 위한 프로바이더
class NavigationProvider extends ChangeNotifier {
  int _index = 0;
  int get currentNavigationIndex => _index;

  updatePage(int index) {
    _index = index;
    notifyListeners();
  }
}
