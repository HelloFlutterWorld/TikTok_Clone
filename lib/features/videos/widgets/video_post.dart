import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;

  final int index;
  const VideoPost(
      {super.key, required this.onVideoFinished, required this.index});

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/video.mp4");

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      //만약 영상의 길이가 10초이고
      if (_videoPlayerController.value.duration ==
          //현재 사용자의 영상내의 위치가 10초이면
          _videoPlayerController.value.position) {
        //그 말은 영상이 끝났다는 뜻이다.
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    //controller를 초기화 해주어야 한다.
    //왜냐면 위처럼 초기화를 한다고 해도 바로 영상이 불러와지는 것은 아니기 때문이다.
    await _videoPlayerController.initialize();
    //_videoPlayerController.play();
    //build메소드로 하여금 controller가 초기화 되었고
    //모든것이 잘 작동한다는 것을 알도록 아래와 같이 setState
    setState(() {});
    //객체가 변경될 때 호출할 클로저를 등록함.
    //리스너가 영상이 바뀌는 시간, 길이, 끝나는 시간 등을 모두 알려줄 수 있다.
    _videoPlayerController.addListener(_onVideoChange);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    //다음 영상이 완전히 빌드된 후에만 재생되도록
    if (info.visibleFraction == 1 && !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          //fill은 화면전체를 채우는 위젯을 만든다.
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          const Positioned.fill(
            //클릭무시하는 위젯
            child: IgnorePointer(
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.play,
                  color: Colors.white,
                  size: Sizes.size52,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
