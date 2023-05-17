import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  void _onNotficationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        //actions: [CloseButton()],
      ),
      body: ListView(
        children: [
          CupertinoSwitch(
            value: _notifications,
            onChanged: _onNotficationsChanged,
          ),
          //adaptive 기기에 따라 바뀜
          SwitchListTile.adaptive(
            value: _notifications,
            onChanged: _onNotficationsChanged,
            title: const Text("Enable notifications"),
            subtitle: const Text("Enable notifications"),
          ),
          Checkbox(
            value: _notifications,
            onChanged: _onNotficationsChanged,
          ),
          CheckboxListTile(
            activeColor: Colors.black,
            //value는 체크박스의 상태를 나타냄
            value: _notifications,
            onChanged: _onNotficationsChanged,
            title: const Text("Enable notifications"),
          ),
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );
              print(date);
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              print(time);
              final booking = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2030),
                  //매개변수로 받는 child는 칼렌다이다.
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData(
                        appBarTheme: const AppBarTheme(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  });
              print(booking);
            },
            title: const Text(
              "What is your birthday?",
            ),
          ),
          const AboutListTile(),
        ],
      ),
    );
  }
}
