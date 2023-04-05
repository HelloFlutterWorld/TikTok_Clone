import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;

  final int index;
  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  //애니메이션이 필요할 때 매 프레임마다
  //SingleTickerProviderStateMixin는 current tree가 활성화된 동안만
  //즉 위젯이 화면이 보일 때만, tick하는 단일 ticker를 제공(즉 Ticker가 tick)한다.
  //7.7 SingleTickerProviderStateMixin 참조
  // 1. 애니메이션은 Ticker가 필요하다 왜냐면 매 프레임마다 재생되어야 하니까
  // 2. 하지만 Ticker가 항상 활성화 상태면 안되고 controller도 하나이므로 Single을 사용한다.
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/video.mp4");

  final hashtags = [
    '#korea',
    '#siheung',
    '#ducks',
    '#offspring',
    '#river',
    '#hometown',
    '#summer'
  ];

  bool _isFullHashtag = false;

  bool _isPaused = false;

  final Duration _animationDuratrion = const Duration(milliseconds: 200);

  late final AnimationController _animationController;

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

    //VisibilityDetetor를 사용하면서 아래의 오토플레이를 지웠음
    //_videoPlayerController.play();

    // 영상이 끝나면 화면 넘김 없이 제자리에서 계속 반복
    // _onVideoChanged를 호출해도 아무것도 반환 받지 않음으로 수정
    await _videoPlayerController.setLooping(true);

    //객체가 변경될 때 호출할 클로저를 등록함.
    //리스너가 영상이 바뀌는 시간, 길이, 끝나는 시간 등을 모두 알려줄 수 있다.

    _videoPlayerController.addListener(_onVideoChange);

    //build메소드로 하여금 controller가 초기화 되었고
    //모든것이 잘 작동한다는 것을 알도록 아래와 같이 setState
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    //이 시계는 매 애니메이션의 프레임마다 fucntion을 제공한다.
    //에니메이션에 callback을 제공해주는 게 바로 Ticker이다
    _animationController = AnimationController(
      //vsync는 offscreen 애니메이션의 불필요한 리소스를 막아줌
      // 즉 위젯이 안 보일 때는 애니메이션이 작동하지 않도록 해줌
      vsync: this,
      //vsync는 애니메이션 재생을 도와주고
      //위젯이 위젯 tree에 있을 때만 Ticker를 유지해준다.
      lowerBound: 1.0,
      upperBound: 1.5,
      //value 는 기본값이다.
      value: 1.5,
      duration: _animationDuratrion,
    );
    // 방법 1
    //_animationController.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    //다음 영상이 완전히 빌드된 후에만 재생되도록
    //visibleFraction는 위젯이 얼마나 보이는 지를 나타내는 0이상 1이하 범위의 수
    if (info.visibleFraction == 1 && !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
      //reverse:  value(1.5) => lowerBound(1.0)
      // or upperBound(1.5) => upperBound(1.0)
    } else {
      _videoPlayerController.play();
      _animationController.forward();
      //forward: lowerBound(1.0)  => upperBound(1.5)
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _seeMoreTap() {
    setState(() {
      _isFullHashtag = !_isFullHashtag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      //visibility가 바뀔 때 호출할 콜백함수
      //영상이 처음 초기화 되는 것도 visibility가 바뀌는 것으로 인식하여
      //처음부터 호출됨
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
          Positioned.fill(
            //클릭무시하는 위젯
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  //방법2
                  //animation은 Listenable 타입이다.
                  //_animationController를 감지한다.
                  animation: _animationController,
                  //builder는 애니메이션 컨트롤러거 변할 때마다 실행됨
                  //_animationController가 변할 때마다 setState가
                  // build를 실행하고 build 메서드가 가장 최신값으로 rebuild하는
                  // 일을 대신해줌
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      //animated를 하고 싶은 child인
                      //AnimatedOpacity를 넘겨준다.
                      //child는 옵셔널 파라미터다. return 값은 widget
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    //lowBound = 0
                    //upperBound = 1
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuratrion,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "@Yoon",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size20,
                  ),
                ),
                Gaps.v10,
                const Text(
                  "These are ducks in the river in my hometown!!!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size16,
                  ),
                ),
                Gaps.v10,
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: Text(
                        hashtags.join(' '),
                        maxLines: _isFullHashtag ? hashtags.length : 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: Sizes.size16,
                        ),
                      ),
                    ),
                    Gaps.h5,
                    GestureDetector(
                      onTap: _seeMoreTap,
                      child: Text(
                        _isFullHashtag ? "   닫기" : "더 보기",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: const [
                //이미지가 있는 원을 제공해 줌
                CircleAvatar(
                  //아바타의 크기
                  radius: 25,
                  //이미지가 로드되지 않을 경우를 대비해서
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://d1telmomo28umc.cloudfront.net/media/public/avatars/customs0529-1679985124.jpg"),
                  child: Text("Yoon"),
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: "2.9M",
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.solidComment,
                  text: "33K",
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: "Share",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
