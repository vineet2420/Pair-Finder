import 'package:flutter/material.dart';

class TabStateProvider extends ChangeNotifier {
 int tab = 0;

  void changeTab(int tab) {
    this.tab = tab;
    notifyListeners();
  }
}