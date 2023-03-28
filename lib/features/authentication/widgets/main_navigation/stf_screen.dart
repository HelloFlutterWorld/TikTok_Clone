import 'package:flutter/material.dart';

class StfScreen extends StatefulWidget {
  const StfScreen({super.key});

  @override
  State<StfScreen> createState() => _StfScreenState();
}

class _StfScreenState extends State<StfScreen> {
  int _clicks = 0;

  void _increase() {
    setState(() {
      _clicks = _clicks + 1;
    });
  }

  void _decrease() {
    setState(() {
      _clicks = _clicks - 1;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$_clicks",
            style: const TextStyle(
              fontSize: 48,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _increase,
                child: const Text(
                  "+",
                  style: TextStyle(
                    fontSize: 36,
                  ),
                ),
              ),
              TextButton(
                onPressed: _decrease,
                child: const Text(
                  "-",
                  style: TextStyle(
                    fontSize: 36,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
