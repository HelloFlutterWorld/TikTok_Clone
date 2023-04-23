import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

//Ticker는 모든 애니메이션 프레임에서 Callback Function을 호출하는 시계 같은 역할을 한다.
//SingleTickerProviderStateMixin는 Ticker를 주는 Mixin 일뿐만아니라
//위젯이 widget tree에 없을 때 resource를 낭비하고 있지 않게 하기도 한다.
class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  //late final AnimationController _animationController =  _animationController = AnimationController(vsync: this);
  //this나 다른 인스턴트 멤버를 참조하려면 late를 사용해주어야 한다. 이럴경우 initstate는 필요없다.

  //이렇게 하면 Animation Builder나 build 메소드를 트리거하거나 setState를 설정하지 않아도 된다.
  late final Animation<double> _arrowAnimation =
      Tween(begin: 0.0, end: 0.5).animate(_animationController);

  late final Animation<Offset> _panelAnimation = Tween(
    //시작위치 가로축과 세로축
    begin: const Offset(0, -1),
    //종류위치 가로축과 세로축
    end: Offset.zero,
    //arrowAnimation과 동일한 콘트롤러를 사용함
  ).animate(_animationController);

  late final Animation<Color?> _barrierAnimation = ColorTween(
    begin: Colors.transparent,
    end: Colors.black38,
  ).animate(_animationController);

  final List<String> _notifications = List.generate(20, (index) => "${index}h");

  final List<Map<String, dynamic>> _tabs = [
    {
      "title": "All activity",
      "icon": FontAwesomeIcons.solidMessage,
    },
    {
      "title": "Likes",
      "icon": FontAwesomeIcons.solidHeart,
    },
    {
      "title": "Comments",
      "icon": FontAwesomeIcons.solidComments,
    },
    {
      "title": "Mentions",
      "icon": FontAwesomeIcons.at,
    },
    {
      "title": "Followers",
      "icon": FontAwesomeIcons.solidUser,
    },
    {
      "title": "From TikTok",
      "icon": FontAwesomeIcons.tiktok,
    }
  ];

  bool _showBarrier = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 400,
      ),
    );
  }

  void _onDismissed(String notification) {
    _notifications.remove(notification);
    //notification 이 삭제되면 키 값에도 반영되어
    //삭제된 체로 리빌드된다.
    setState(() {});
  }

  void _toggleAnimations() async {
    if (_animationController.isCompleted) {
      //리버스를 실행할 때는 await를 하고
      await _animationController.reverse();
    } else {
      _animationController.forward();
    }

    //_animationController.isCompleted이 참인경우
    //reverse()와 아래 문장의 setState()가 동시에 실행되어 배리어도 곧바로 사라진다.
    //왜냐면 if(_showBarrier) AnimatedModalBarrier(...)
    //이때 build가 다시 되고 그 즉시 AnimatedModalBarrier가 위젯에서도 사라잔다.
    //build는 애니메이션 동작이 완료되는 것을 기다려 주지 않고 배리어를 사라지게 한다.
    //다행이 reverse와 forward는 모두 Future를 리턴하는데,
    //Future는 애니메이션이 다 끝나야 완료되므로,
    //await를 적어주어 애니메이션이 다 끝나야 아래 문장을 실행할 수 있도록 한다.
    setState(() {
      _showBarrier = !_showBarrier;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(_notifications);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _toggleAnimations,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "All activity",
              ),
              Gaps.h2,
              RotationTransition(
                turns: _arrowAnimation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.size14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Gaps.v14,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size12,
                ),
                child: Text(
                  "New",
                  style: TextStyle(
                    fontSize: Sizes.size14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              Gaps.v14,
              for (var notification in _notifications)
                Dismissible(
                  //고유키를 설정해주고, .setState로 리빌드해주면
                  //Dismiss한 아이템들이 아예 위젯트리에서 사라지게 된다.\
                  //따라서 에러가 발생하지 않는다.
                  key: Key(notification),
                  //방향은 startToEnd 또는 endToStart다
                  //방향에 신경쓸 것 없다. 어느 방향이건 동작을 하게끔 설정할 것이므로
                  onDismissed: (direction) => _onDismissed(notification),
                  //왼쪽 색상 등
                  background: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.green,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: Sizes.size10,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.checkDouble,
                        color: Colors.white,
                        size: Sizes.size32,
                      ),
                    ),
                  ),
                  //오른쪽 색상 등
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        right: Sizes.size10,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.white,
                        size: Sizes.size24,
                      ),
                    ),
                  ),
                  child: ListTile(
                    //줄 간격
                    minVerticalPadding: Sizes.size16,
                    //왼쪽 위젯
                    leading: Container(
                      width: Sizes.size52,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: Sizes.size1,
                        ),
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.bell,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    //오른쪽 위젯(아이콘)
                    trailing: const FaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: Sizes.size16,
                    ),
                    title: RichText(
                      text: TextSpan(
                        text: "Account updates:",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: Sizes.size16,
                        ),
                        children: [
                          const TextSpan(
                            text: " Upload longer videos",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: " $notification",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (_showBarrier)
            AnimatedModalBarrier(
              color: _barrierAnimation,
              //배리어를 터치할 때 반응할 것인가?
              dismissible: true,
              onDismiss: _toggleAnimations,
            ),
          //"end: Colors.black38"의 영향을 처음부터 받지 않도록 여기에 위치시킴
          //왜냐면 스택이기때문, 스택은 맨 마지막 노드가 위에 온다.
          SlideTransition(
            position: _panelAnimation,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    Sizes.size5,
                  ),
                  bottomRight: Radius.circular(
                    Sizes.size5,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var tab in _tabs)
                    ListTile(
                      title: Row(
                        children: [
                          FaIcon(
                            tab["icon"],
                          ),
                          Gaps.h20,
                          Text(
                            tab['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
