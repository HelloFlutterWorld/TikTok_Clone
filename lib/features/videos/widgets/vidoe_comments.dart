import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  bool _isWriting = false;

  final ScrollController _scrollCotroller = ScrollController();

  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  void _onStopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  //내가 추가한 코드
  @override
  void dispose() {
    _scrollCotroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //현재 사용자의 스마트폰의 크기를 반환받은
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: size.height * 0.75,
        constraints: const BoxConstraints(maxWidth: Breakpoints.md),
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
          body: GestureDetector(
            onTap: _onStopWriting,
            child: Stack(
              children: [
                Scrollbar(
                  //스크롤바를 사용할 포지션도 같이 선언
                  controller: _scrollCotroller,
                  child: ListView.separated(
                    controller: _scrollCotroller,
                    separatorBuilder: (context, index) => Gaps.v20,
                    itemCount: 10,
                    padding: const EdgeInsets.only(
                      left: Sizes.size16,
                      right: Sizes.size16,
                      top: Sizes.size10,
                      //positioned 가 코멘트들을 가리지 않도록
                      bottom: Sizes.size96 + Sizes.size20,
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
                            child: SizedBox(
                              height: Sizes.size44,
                              child: TextField(
                                onTap: _onStartWriting,
                                expands: true,
                                minLines: null,
                                maxLines: null,
                                //return을 누르면 다음 줄이 생겨서
                                //여러줄을 입력할 수 있게해붐
                                textInputAction: TextInputAction.newline,
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
                                    //작은 값을 입력하면 영향을 안 줌
                                    //따라서 SizedBox로 크기를 따로 지정함
                                    vertical: Sizes.size10,
                                    horizontal: Sizes.size12,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                      right: Sizes.size14,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.at,
                                          color: Colors.grey.shade900,
                                        ),
                                        Gaps.h14,
                                        FaIcon(
                                          FontAwesomeIcons.gift,
                                          color: Colors.grey.shade900,
                                        ),
                                        Gaps.h14,
                                        FaIcon(
                                          FontAwesomeIcons.faceSmile,
                                          color: Colors.grey.shade900,
                                        ),
                                        if (_isWriting) Gaps.h14,
                                        if (_isWriting)
                                          GestureDetector(
                                            onTap: _onStopWriting,
                                            child: FaIcon(
                                              FontAwesomeIcons.circleArrowUp,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
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
        ),
      ),
    );
  }
}
