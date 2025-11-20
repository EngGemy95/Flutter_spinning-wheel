
import 'package:flutter/material.dart';


class NameProvider extends ChangeNotifier {
  final List<String> _names = [];
  List<String> get names => _names;

  void addName(String name) {
    if (name.isNotEmpty) {
      _names.add(name);
      notifyListeners();
    }
  }

  void clearNames() {
    _names.clear();
    notifyListeners();
  }
  void removeName(int index) {
    _names.removeAt(index);
    notifyListeners();
  }
}
