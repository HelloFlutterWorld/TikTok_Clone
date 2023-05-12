import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/%20users/widgets/persistent_tab_bar.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //텝바는 콘틀로러가 필요하므로 화면 전체를
    //DefaultTabController로 감싸줌, 탭은 총 2개
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        // NestedScrollView를 사용하여 스크롤 문제를 해결한다.
        //NestedScrollView는 여럭 개의 스크롤 가능한 view들을 넣을 수 있게 해준다.
        //그 안의 모든 스크롤 포지션들을 연결해준다.
        //보통 슬리버앱바와 탭바를 동시에 사용하는 경우의 문제를 해결해준다.
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: const Text("Yoon"),
                actions: [
                  IconButton(
                    onPressed: _onGearPressed,
                    icon: const FaIcon(
                      FontAwesomeIcons.gear,
                      size: Sizes.size20,
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      foregroundImage: NetworkImage(
                          "https://d1telmomo28umc.cloudfront.net/media/public/avatars/customs0529-1679985124.jpg"),
                      child: Text("Yoon"),
                    ),
                    Gaps.v20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "@Yoon",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.size18,
                          ),
                        ),
                        Gaps.h5,
                        FaIcon(
                          FontAwesomeIcons.solidCircleCheck,
                          size: Sizes.size16,
                          color: Colors.blue.shade500,
                        ),
                      ],
                    ),
                    Gaps.v24,
                    SizedBox(
                      //VerticalDivider는 father의 높이를 따른다.
                      //Row는 높이가 없기 때문에 SizedBox로 감싸준다.
                      height: Sizes.size48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "97",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size18,
                                ),
                              ),
                              Gaps.v5,
                              Text(
                                "Following",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          VerticalDivider(
                            //위젯이 차지하는 수평공간
                            width: Sizes.size32,
                            thickness: Sizes.size1,
                            color: Colors.grey.shade400,
                            //막대의 들여쓰기
                            indent: Sizes.size14,
                            endIndent: Sizes.size14,
                          ),
                          Column(
                            children: [
                              const Text(
                                "10M",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size18,
                                ),
                              ),
                              Gaps.v3,
                              Text(
                                "Followers",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          VerticalDivider(
                            //위젯이 차지하는 수평공간
                            width: Sizes.size32,
                            thickness: Sizes.size1,
                            color: Colors.grey.shade400,
                            //막대의 들여쓰기
                            indent: Sizes.size14,
                            endIndent: Sizes.size14,
                          ),
                          Column(
                            children: [
                              const Text(
                                "194.3M",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size18,
                                ),
                              ),
                              Gaps.v3,
                              Text(
                                "Likes",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gaps.v14,
                    //father의 너비와 높이에 의존해서 너비와 높이를 가진다.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.33,
                          height: Sizes.size40 + Sizes.size1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: Sizes.size12,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  Sizes.size4,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Follow",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Gaps.h3,
                        Container(
                          alignment: Alignment.center,
                          width: Sizes.size40,
                          height: Sizes.size40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.youtube,
                            size: Sizes.size20,
                          ),
                        ),
                        Gaps.h3,
                        Container(
                          alignment: Alignment.center,
                          width: Sizes.size40,
                          height: Sizes.size40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Icon(
                            Icons.arrow_drop_down_outlined,
                            size: Sizes.size24,
                          ),
                        ),
                      ],
                    ),

                    Gaps.v14,
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.size32,
                      ),
                      child: Text(
                        "All highlights and where to watch live matches on FIFA+ I wonder how it would look",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gaps.v14,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.link,
                          size: Sizes.size12,
                        ),
                        Gaps.h4,
                        Text(
                          "https://nomadcoders.co",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Gaps.v20,
                  ],
                ),
              ),
              //SliverPersistentHeader는 SliverToBoxAdapter안에서 사용될 수 없다.
              //부모자식관계가 아닌 형제관계가 되어야 한다.
              //따라서 아래와 같이 따로 빼준다.
              SliverPersistentHeader(
                delegate: PersistentTabBar(),
                pinned: true,
                floating: true,
              ),
            ];
          },
          //그리드뷰와 탑바뷰는 헤더이 있어서는 안된다.
          body: TabBarView(
            children: [
              GridView.builder(
                //스크롤할때는 키보드가 사라지도록
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: 20,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //세로 갯수
                  crossAxisCount: 3,
                  //가로 간격
                  crossAxisSpacing: Sizes.size2,
                  //세로 간격
                  mainAxisSpacing: Sizes.size2,
                  //가로세로 비욜
                  childAspectRatio: 9 / 14,
                ),
                itemBuilder: (context, index) => Column(
                  children: [
                    //종행비율 조절위젯
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 9 / 14,
                          child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: "assets/images/image.jpg",
                            image:
                                "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80",
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.play_arrow_outlined,
                                color: Colors.white,
                                size: Sizes.size28,
                              ),
                              Text(
                                '${(Random().nextDouble() * 10).toStringAsFixed(1)}M',
                                style: const TextStyle(
                                  fontSize: Sizes.size16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text(
                  "Page two ",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
