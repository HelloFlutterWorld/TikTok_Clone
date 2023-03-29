import 'package:flutter/material.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.teal,
  ];

  void _onPageChanged(int page) {
    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
      colors.addAll(
        [
          Colors.blue,
          Colors.red,
          Colors.yellow,
          Colors.teal,
        ],
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      //자동넘김
      //pageSnapping: false,
      //유저가 이동할 때 도착하는 페이지에 대한 정보를 제공하는 메쏘드
      onPageChanged: _onPageChanged,
      scrollDirection: Axis.vertical,
      itemCount: _itemCount,
      itemBuilder: (context, index) => Container(
        color: colors[index],
        child: Center(
          child: Text(
            "Screen $index",
            style: const TextStyle(
              fontSize: 68,
            ),
          ),
        ),
      ),
    );
  }
}
