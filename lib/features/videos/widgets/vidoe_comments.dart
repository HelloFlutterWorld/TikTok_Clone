import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    //현재 사용자의 스마트폰의 크기를 반환받은
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.75,
      //자식인 스카폴드가 컨테이너의 경계를 침범하면 바로 자름
      //따라서 모서리의 곡선효과가 계속 유지됨
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Sizes.size14,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          //앱바에서 자동으로 제공해주는 뒤로가기(pop())버튼 없애기
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey.shade50,

          title: const Text("22796 comments"),
          actions: [
            IconButton(
              onPressed: _onClosePressed,
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView.separated(
              separatorBuilder: (context, index) => Gaps.v20,
              itemCount: 10,
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size10,
                horizontal: Sizes.size16,
              ),
              itemBuilder: (context, index) => Row(
                //아바타틀 Row의 위로 오도록
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 18,
                    child: Text("니꼬"),
                  ),
                  Gaps.h10,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nico",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Sizes.size14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Gaps.v3,
                        const Text(
                            "That's not it l've seen the same thing but also in a cave,")
                      ],
                    ),
                  ),
                  Gaps.h10,
                  Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.heart,
                        size: Sizes.size20,
                        color: Colors.grey.shade500,
                      ),
                      Gaps.v2,
                      Text(
                        "52.2K",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //bottomNavigationBar는 기본적으로 키보드가 나오면
            //밑에 숨겨지기 때문에 Positioned를 사용한다.
            Positioned(
              bottom: 0,
              width: size.width,
              child: BottomAppBar(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size16,
                    vertical: Sizes.size10,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.shade500,
                        foregroundColor: Colors.white,
                        child: const Text("니꼬"),
                      ),
                      Gaps.h10,
                      Expanded(
                        child: TextField(
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            hintText: "Add comment...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Sizes.size12,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: Sizes.size10,
                              horizontal: Sizes.size12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
