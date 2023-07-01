import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatDetailScreen extends StatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatId";

  final String chatId;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  bool _isWriting = false;

  @override
  void initState() {
    _textEditingController.addListener(() {
      setState(() {
        _isWriting = _textEditingController.text.isNotEmpty;
      });
    });
    //재정의된 이니트스테이트를 실행후에 부모클래스의 이니트스테이트를 한번 더 실행함
    super.initState();
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = _textEditingController.text.isNotEmpty;
    });
  }

  void _onSendMessage() {
    setState(() {
      _isWriting = false;
      _textEditingController.clear();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: Sizes.size8,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: Sizes.size24,
                      foregroundImage: NetworkImage(
                          "https://avatars.githubusercontent.com/u/123614459?v=4"),
                      child: Text("Yoon"),
                    ),
                    Positioned(
                      bottom: -3,
                      right: -3,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(
                            width: Sizes.size3,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.size10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            title: Text(
              "Yoon (${widget.chatId})",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              "Active now",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                FaIcon(
                  FontAwesomeIcons.flag,
                  color: Colors.black,
                  size: Sizes.size20,
                ),
                Gaps.h32,
                FaIcon(
                  FontAwesomeIcons.ellipsis,
                  color: Colors.black,
                  size: Sizes.size20,
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size20,
                horizontal: Sizes.size14,
              ),
              itemBuilder: (context, index) {
                //2로 나줘지면 나의 메시지
                final isMine = index % 2 == 0;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(
                        Sizes.size14,
                      ),
                      decoration: BoxDecoration(
                        color: isMine
                            ? Colors.blue
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(
                            Sizes.size20,
                          ),
                          topRight: const Radius.circular(
                            Sizes.size20,
                          ),
                          bottomLeft: Radius.circular(
                            isMine ? Sizes.size20 : Sizes.size5,
                          ),
                          bottomRight: Radius.circular(
                            !isMine ? Sizes.size20 : Sizes.size5,
                          ),
                        ),
                      ),
                      child: const Text(
                        "This is a message!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size16,
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Gaps.v10,
              itemCount: 10,
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: BottomAppBar(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size16,
                  vertical: Sizes.size10,
                ),
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    //Expanded 없으면 에러남
                    //왜냐면, TextField의 width를 설정하지 않았음으로
                    Expanded(
                      child: SizedBox(
                        height: Sizes.size44,
                        child: TextField(
                          controller: _textEditingController,
                          onTap: _onStartWriting,
                          expands: true,
                          minLines: null,
                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Send a message...",
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: Sizes.size10,
                              horizontal: Sizes.size12,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(
                                right: Sizes.size8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Gaps.h14,
                                  FaIcon(
                                    FontAwesomeIcons.faceSmile,
                                    color: Colors.grey.shade900,
                                  ),
                                ],
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Sizes.size20),
                                topRight: Radius.circular(Sizes.size20),
                                bottomLeft: Radius.circular(Sizes.size20),
                                bottomRight: Radius.circular(Sizes.size5),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gaps.h20,
                    GestureDetector(
                      onTap: _onSendMessage,
                      child: FaIcon(
                        FontAwesomeIcons.paperPlane,
                        color: _isWriting ? Colors.black : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
