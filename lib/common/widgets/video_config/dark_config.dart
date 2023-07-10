import 'package:flutter/cupertino.dart';

final systemDarkMode = ValueNotifier(false);

class DarkConfig extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleIsDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
