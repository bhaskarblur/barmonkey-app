import 'package:flutter/material.dart';

class HomeScreenProvider with ChangeNotifier {
  int _selectedIndex = 2;
  int get selectedIndex => _selectedIndex;

  changeSelectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
