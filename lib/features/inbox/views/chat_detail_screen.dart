import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/utils.dart';

class ChatDetailScreenArg {
  final bool isFromChatList;
  final UserProfileModel profile;
  final ChatRoomModel chatRoom;

  ChatDetailScreenArg({
    required this.profile,
    required this.isFromChatList,
    required this.chatRoom,
  });
}

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatRoomId";

  final String chatRoomId;
  final UserProfileModel profile;
  final ChatRoomModel chatRoom;
  final bool isFromChatList;

  const ChatDetailScreen(
      {super.key,
      required this.chatRoomId,
      required this.profile,
      required this.chatRoom,
      required this.isFromChatList});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
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
    final text = _textEditingController.text;
    if (text == "") {
      return;
    }
    ref
        .read(messagesProvider.notifier)
        .sendMessage(text: text, chatRoomId: widget.chatRoomId);
    _textEditingController.text = "";
    setState(() {
      _isWriting = false;
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider).isLoading;
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
                    CircleAvatar(
                      radius: Sizes.size24,
                      foregroundImage: widget.profile.hasAvater
                          ? NetworkImage(widget.isFromChatList
                              ? "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-qwer.appspot.com/o/avatars%2F${widget.chatRoom.listenerId}?alt=media"
                              : "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-qwer.appspot.com/o/avatars%2F${widget.profile.uid}?alt=media")
                          : null,
                      child: Text(
                        widget.isFromChatList
                            ? "${widget.chatRoom.listenerName}"
                            : widget.profile.name,
                        overflow: TextOverflow.ellipsis,
                      ),
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
              widget.isFromChatList
                  ? "${widget.chatRoom.listenerName}"
                  : widget.profile.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              "Active now",
            ),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
            ref.watch(chatProvider(widget.chatRoomId)).when(
                  // data가 있을 때 아래의 문장들을 수행한다.
                  data: (data) {
                    final messageProvider =
                        ref.watch(messagesProvider.notifier);
                    return ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.only(
                        top: Sizes.size20,
                        bottom: MediaQuery.of(context).padding.bottom +
                            Sizes.size96,
                        left: Sizes.size14,
                        right: Sizes.size14,
                      ),
                      itemBuilder: (context, index) {
                        final message = data[index];
                        final isMine =
                            message.userId == ref.watch(authRepo).user!.uid;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isMine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                final is2Minutes =
                                    isWithin2Minutes(message.createdAt);
                                final isDeleted =
                                    data[index].text == "[deleted]";
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: isDeleted
                                        ? const Text("이미 삭제된 메시지입니다.")
                                        : Text(is2Minutes
                                            ? "메시지를 삭제할까요?"
                                            : "2분이 경과하면 메시지를 삭제할 수 없습니다."),
                                    // content: const Text("Plx dont go"),
                                    actions: [
                                      CupertinoDialogAction(
                                        //현재 새로운 Route를 push한 상태이므로 pop해준다.
                                        onPressed: () {
                                          if (is2Minutes) {
                                            messageProvider.deleteMessage(
                                                widget.chatRoomId,
                                                message.messageId!);
                                            Navigator.of(context).pop();
                                          } else {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        isDestructiveAction:
                                            is2Minutes && !isDeleted
                                                ? false
                                                : true,
                                        child: const Text("예"),
                                      ),
                                      if (is2Minutes && !isDeleted)
                                        CupertinoDialogAction(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          //No Yes 색깔 바뀜 뭔지 모르겠음
                                          isDestructiveAction: true,
                                          child: const Text("아니오"),
                                        ),
                                    ],
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (isMine) ...[
                                    Text(convertTimeStamp(message.createdAt)),
                                    Gaps.h7,
                                  ],
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
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 240,
                                      ),
                                      child: Text(
                                        message.text,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: Sizes.size16,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!isMine) ...[
                                    Gaps.h7,
                                    Text(convertTimeStamp(message.createdAt)),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => Gaps.v10,
                      itemCount: data.length,
                    );
                  },
                  error: (error, stackTrace) => Center(
                    child: Text(
                      error.toString(),
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.only(
                  left: Sizes.size16,
                  right: Sizes.size16,
                  top: Sizes.size10,
                  bottom: Sizes.size32,
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
                          // expands: true,
                          // minLines: null,
                          // maxLines: null,
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
                      onTap: isLoading ? null : _onSendMessage,
                      child: FaIcon(
                        isLoading
                            ? FontAwesomeIcons.hourglass
                            : FontAwesomeIcons.paperPlane,
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
