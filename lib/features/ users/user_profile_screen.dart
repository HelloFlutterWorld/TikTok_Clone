import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

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
          //플로팅과 동시에 사용시 스크롤을 조금만 올려도
          //앱바가 배경이미지와 함께 다시 나타남
          //snap: true,
          //스크로을 올리면(as soon as the user scrolls towards the app bar)
          //그 자리에서 즉시 앱바가 나타맘.
          //floating: true,
          //앱바 전체를 밑으로 당겨서 늘리는 것도 가능하게 해줌
          stretch: true,
          //앱바의 배경색과 title을 보여준다.
          //스크롤이 다 올라와야지만 배경이미지가 보여진다.
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
              StretchMode.fadeTitle,
            ],
            background: Image.asset(
              "assets/images/image.jpg",
              fit: BoxFit.cover,
            ),
            title: const Text("Hello!"),
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            childCount: 50,
            (context, index) => Container(
              color: Colors.amber[100 * (index % 9)],
              child: Align(
                  alignment: Alignment.center, child: Text("Item $index")),
            ),
          ),
          itemExtent: 100,
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            childCount: 50,
            (context, index) => Container(
              color: Colors.blue[100 * (index % 9)],
              child: Align(
                alignment: Alignment.center,
                child: Text("Item $index"),
              ),
            ),
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            mainAxisSpacing: Sizes.size20,
            crossAxisSpacing: Sizes.size20,
            childAspectRatio: 1,
          ),
        ),
      ],
    );
  }
}
