import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/widgets/video_post.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  final PageController _pageController = PageController();
  final Duration _scrollDuration = const Duration(milliseconds: 250);
  final Curve _scrollCurve = Curves.linear;

  void _onPageChanged(int page) {
    //사용자가 직접 패이지를 스크롤 할 때
    //원하는 페이지로 애니메이션을 보낸다.
    _pageController.animateToPage(
      //원하는 페이지
      page,
      duration: _scrollDuration,
      //curve는 보여주려는 애니메이션의 종류를 뜻함
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
      setState(() {});
    }
  }

  void _onVideoFinished() {
    return;
    //영상이 종료될 때 실행하여
    //_onPageChanged를 호출
    //_pageController.nextPage(duration: _scrollDuration, curve: _scrollCurve);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    return Future.delayed(
      const Duration(
        seconds: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      //화면을 당기기 시작할 때 처음 나타나는
      //edgeoffset으로부터 아래로의 indicator의 위치를 정하는 값
      displacement: 50,
      //화면을 당길 때 indicator가 처음 나타나는 위치를 정함
      edgeOffset: 20,
      color: Theme.of(context).primaryColor,
      child: PageView.builder(
        //자동넘김
        //pageSnapping: false,
        //유저가 이동할 때 도착하는 페이지에 대한 정보를 제공하는 메쏘드
        controller: _pageController,
        //사용자가 직접 패이지를 스크롤 할 때
        onPageChanged: _onPageChanged,
        scrollDirection: Axis.vertical,
        itemCount: _itemCount,
        itemBuilder: (context, index) => VideoPost(
          onVideoFinished: _onVideoFinished,
          index: index,
        ),
      ),
    );
  }
}
