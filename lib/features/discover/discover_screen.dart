import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _textEditingController = TextEditingController(
    text: "Initial Text",
  );

  void _onSearchChanged(String value) {
    // print("Searching form $value");
  }

  void _onSearchSubmitted(String value) {
    // print("Submitted $value");
  }

  void _hidingKeyboard() {
    FocusScope.of(context).unfocus();
  }

  // void _onClearTap() {
  //   _textEditingController.clear();
  // }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    //Tab는 controller를 필요로 하는데
    //이 에러를 해결하는 가장 간단한 방법은 Tab을 DefaultTabController 안에
    //넣어주는 것이다. 그리고 디폴트로 갯수를 지정해 준다.
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        //키보드가 올라와도 화면이 찌그러지지 않도록
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          title: Container(
              constraints: const BoxConstraints(
                maxWidth: Breakpoints.sm,
              ),
              child: CupertinoSearchTextField(
                controller: _textEditingController,
                onChanged: _onSearchChanged,
                onSubmitted: _onSearchSubmitted,
                style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : Colors.black),
              )
              /* Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    size: Sizes.size28,
                    color: Colors.black,
                  ),
                  Gaps.h12,
                  Expanded(
                    child: SizedBox(
                      height: Sizes.size44,
                      child:
                      TextField(
                        controller: _textEditingController,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Sizes.size4,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: isDarkMode(context)
                              ? Colors.black
                              : Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: Sizes.size10,
                            horizontal: Sizes.size12,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Sizes.size10,
                              horizontal: Sizes.size12,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                FaIcon(
                                  FontAwesomeIcons.magnifyingGlass,
                                  size: Sizes.size16 + Sizes.size2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          suffix: GestureDetector(
                            onTap: _onClearTap,
                            child: FaIcon(
                              FontAwesomeIcons.solidCircleXmark,
                              color: Colors.grey.shade500,
                              size: Sizes.size16 + Sizes.size2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gaps.h12,
                  const Icon(
                    Icons.format_align_center,
                    size: Sizes.size28,
                  ),
                ],
              ), */
              ),
          //PreferredSizeWidget: 특정한 크기를 가지려고 하지만
          //자식요소의 크기를 제한하지 않는 위젯
          //즉 자식요소가 부모요소의 제한을 받지 않는다.
          //bottom: PreferredSize(child: Container()),
          bottom: TabBar(
            onTap: (value) => _hidingKeyboard(),
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
            //원래는 자동으로 적용되어야 하는데 알수 없는 이유로 버그가 발생
            //메인에서 설정해준 값을 못가져와서 버그해결해줌
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //gridDelegate는 컨트롤러와는 약간 다른, 도우미같은 느낌이다.
            GridView.builder(
              //스크롤할때는 키보드가 사라지도록
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: 20,
              padding: const EdgeInsets.all(
                Sizes.size6,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //세로 갯수
                crossAxisCount: width > Breakpoints.lg ? 5 : 2,
                //가로 간격
                crossAxisSpacing: Sizes.size10,
                //세로 간격
                mainAxisSpacing: Sizes.size10,
                //가로세로 비욜
                childAspectRatio: 9 / 20,
              ),
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constrints) => Column(
                  children: [
                    //종행비율 조절위젯
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Sizes.size4,
                        ),
                      ),
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: "assets/images/image.jpg",
                          image:
                              "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80",
                        ),
                      ),
                    ),
                    Gaps.v10,
                    const Text(
                      "This is a very long caption for my tiktok that im upload just now currently.",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: Sizes.size16 + Sizes.size2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v8,
                    //200에서 250사이는 안보이게
                    //column은 작은 화면에서도 작아질 수 있지만, 큰 화면에서도 작아질 수 있다.
                    if (constrints.maxWidth < 205 || constrints.maxWidth > 250)
                      DefaultTextStyle(
                        style: TextStyle(
                          color: isDarkMode(context)
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(
                                "https://avatars.githubusercontent.com/u/123614459?v=4",
                              ),
                            ),
                            Gaps.h4,
                            const Expanded(
                              child: Text(
                                "My avatar is going to be very long",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gaps.v4,
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: Sizes.size16,
                              color: Colors.grey.shade600,
                            ),
                            Gaps.h2,
                            const Text(
                              "2.5M",
                            )
                          ],
                        ),
                      ),
                  ],
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
              ),
          ],
        ),
      ),
    );
  }
}
