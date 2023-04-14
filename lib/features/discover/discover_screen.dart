import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Tab는 controller를 필요로 하는데
    //이 에러를 해결하는 가장 간단한 방법은 Tab을 DefaultTabController 안에
    //넣어주는 것이다. 그리고 디폴트로 갯수를 지정해 준다.
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text('Discover'),
          //PreferredSizeWidget: 특정한 크기를 가지려고 하지만
          //자식요소의 크기를 제한하지 않는 위젯
          //즉 자식요소가 부모요소의 제한을 받지 않는다.
          //bottom: PreferredSize(child: Container()),
          bottom: TabBar(
              //스플래쉬효과 없애기
              splashFactory: NoSplash.splashFactory,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size16,
              ),
              isScrollable: true,
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
              //밑줄색
              indicatorColor: Colors.black,
              //선택된 탭의 글자색
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.shade500,
              tabs: [
                for (var tab in tabs)
                  Tab(
                    text: tab,
                  )
              ]),
        ),
        body: TabBarView(
          children: [
            //gridDelegate는 컨트롤러와는 약간 다른, 도우미같은 느낌이다.
            GridView.builder(
              itemCount: 20,
              padding: const EdgeInsets.all(
                Sizes.size6,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //세로 갯수
                crossAxisCount: 2,
                //가로 간격
                crossAxisSpacing: Sizes.size10,
                //세로 간격
                mainAxisSpacing: Sizes.size10,
                //가로세로 비욜
                childAspectRatio: 9 / 16,
              ),
              itemBuilder: (context, index) => Container(
                color: Colors.teal,
                child: Center(
                  child: Text("$index"),
                ),
              ),
            ),
            for (var tab in tabs.skip(1))
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
