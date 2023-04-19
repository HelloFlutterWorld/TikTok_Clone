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
  late final Animation<double> _animation =
      Tween(begin: 0.0, end: 0.5).animate(_animationController);

  final List<String> _notifications = List.generate(20, (index) => "${index}h");

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );
  }

  void _onDismissed(String notification) {
    _notifications.remove(notification);
    //notification 이 삭제되면 키 값에도 반영되어
    //삭제된 체로 리빌드된다.
    setState(() {});
  }

  void _onTitleTap() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(_notifications);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _onTitleTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "All activity",
              ),
              Gaps.h2,
              RotationTransition(
                turns: _animation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.size14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
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
              key: Key(notification),
              //왼쪽 색상 등
              onDismissed: (direction) => _onDismissed(notification),
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
                minVerticalPadding: Sizes.size16,
                //컨텐츠패딩 제로
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
    );
  }
}
