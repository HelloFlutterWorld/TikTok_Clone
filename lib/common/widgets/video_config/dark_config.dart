import 'package:flutter/cupertino.dart';

final systemDarkMode = ValueNotifier(false);

// class DarkConfig extends ChangeNotifier {
//   bool isDarkMode = false;

//   void toggleIsDarkMode() {
//     isDarkMode = !isDarkMode;
//     notifyListeners();
//   }
// }
  
/* 
final systemDarkModeProvider = StateNotifierProvider((ref) => DarkModeNotifier());

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier() : super(false);

  void toggleDarkMode() {
    state = !state;
  }
}

...

return Consumer(
  builder: (context, watch, child) {
    final darkMode = watch(systemDarkModeProvider);
    return MaterialApp(
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      ...
    );
  },
);

...

return Consumer(
  builder: (context, watch, child) {
    final darkMode = watch(systemDarkModeProvider);
    return SwitchListTile.adaptive(
      value: darkMode,
      onChanged: (value) {
        final darkModeNotifier = context.read(systemDarkModeProvider.notifier);
        darkModeNotifier.toggleDarkMode();
      },
      title: const Text("Dark Mode"),
      subtitle: const Text("Dark mode will be applied by default."),
    );
  },
);
 */