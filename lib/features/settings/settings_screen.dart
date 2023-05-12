import 'package:flutter/cupertino.dart';
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
      body: Column(
        children: const [
          //아이폰스타일
          CupertinoActivityIndicator(
            radius: 40,
            //animating: false,
          ),
          //안드로이드스타일
          CircularProgressIndicator(),
          //운영체제에 따라 다름
          CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }
}
