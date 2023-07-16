import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/view_models/timeline_view_model.dart';
import 'widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
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
    // View Moder의 build메서드가 데이터를 다 받아올 때까지 기다려야 한다.
    // when은 Provider의 각기 다른 state를 위한  callback들을 제공한다.
    return ref.watch(timeLineProvider).when(
          // Provider가 로딩 중일 때, 즉, API를 기다리고 있을 때,
          // 현재는 5초 딜레이로 설정되어 있음
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              "Could not load videos: $error",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          //videos = List<VideoModel>
          data: (videos) => RefreshIndicator(
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
              // itemCounnt: itemConut => videos.length
              itemCount: videos.length,
              itemBuilder: (context, index) => VideoPost(
                onVideoFinished: _onVideoFinished,
                index: index,
              ),
            ),
          ),
        );
  }
}
