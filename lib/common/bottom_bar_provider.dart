import 'package:flutter/material.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  int _bottomNavigationBarIndex = 0;
  int countItems = 3;

  int get bottomNavigationBarIndex => this._bottomNavigationBarIndex;

  void setBottomNavigationBarIndex(int index) {
    if (index < countItems && index >= 0) {
      _bottomNavigationBarIndex = index;
      notifyListeners();
    }
  }
}
