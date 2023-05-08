import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
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
          title: const Text("Yoon"),
          actions: [
            IconButton(
              onPressed: () {},
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
              )
            ],
          ),
        ),
      ],
    );
  }
}
