import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        //actions: [CloseButton()],
      ),
      body: ListWheelScrollView(
        diameterRatio: 1.5,
        offAxisFraction: 1.5,
        // useMagnifier: true,
        // magnification: 1.5,
        //높이설정
        itemExtent: 200,
        children: [
          for (var x in [1, 2, 1, 21, 2, 1, 2, 1, 2, 1, 2, 1, 2])
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                color: Colors.teal,
                alignment: Alignment.center,
                child: Text(
                  "Pick me $x",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 39,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
