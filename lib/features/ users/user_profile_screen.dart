import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      //슬리버는 스크롤뷰의 일다.
      //사용자들이 스크로할 때 사용하는 것들이다.
      slivers: [
        SliverAppBar(
          floating: true,
          //밑으로 당기는 것도 가능하게 해줌
          stretch: true,
          //앱바는 사라지지 않게 한다.
          pinned: true,
          backgroundColor: Colors.teal,
          //title: const Text("Hello!"),
          //슬리버앱바는 확장될 수 있다.
          //콜랩스까지 줄어들수 있다. title이 사라지기 시작하는 구간이다.
          collapsedHeight: 80,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.blurBackground,
              StretchMode.zoomBackground,
            ],
            background: Image.asset(
              "assets/images/image.jpg",
              fit: BoxFit.cover,
            ),
            title: const Text("Hello!"),
          ),
        )
      ],
    );
  }
}
