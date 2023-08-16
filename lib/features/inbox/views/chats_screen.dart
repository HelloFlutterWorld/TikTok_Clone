import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_room_view_model.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/utils.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = "chats";
  static const String routeURL = "/chats";
  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  List<int> _items = [];

  //AnimatedListState에 접근할 수 있는 key
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final Duration _duration = const Duration(milliseconds: 300);
  int initTotalLength = 0;
  bool isSelfDelete = false;

  void setSelfDelete() {
    isSelfDelete = true;
  }

  void _addItem({
    required int chatRoomsLength,
    required int userListLength,
  }) {
    _items = List.generate(chatRoomsLength, (index) => index);
    // ref.watch(userListProvider).when
    if (_key.currentState != null) {
      //위에서부터(처음부터) 나타나게 하려면
      //_key.currentState!.insertItem(0);
      //아이템을 넣을 위치 0은 맨 처음이다.
      //왜냐면 initialItemCount: 0으로 세팅되어 있기 때문이다.
      for (int user = 0; user < userListLength; user++) {
        _key.currentState!.insertItem(
          _items.length,
          duration: _duration,
        );
        _items.add(_items.length);
      }
    }
  }

  _deleteItem(
    int index,
    UserProfileModel profile,
    ChatRoomModel chatRoom,
    bool isExternalDeleted,
  ) {
    final repo = ref.read(messagesRepo);
    if (_key.currentState != null) {
      //아래의 => 함수는 view로부터 아이템을 삭제할 때 보여주고 싶은 아이템을 반환해야 함
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          //삭제하는 것 처럼 보이지만 실제로는 뭔가를 만들어내고 있다.
          //사용자가 같은 Tile을 보고 있다고 착각하게 만들지만
          //사실은 다시 만들고 잇는 것이다.
          //삭제시 보여준는 위젯이 삭제되는 해당 ListTile 자체여서
          //애니메이션효과가 있다.
          child: isExternalDeleted
              ? null
              : Container(
                  color: Colors.red,
                  child: _makeChatsTile(
                    index,
                    profile,
                    chatRoom,
                  ),
                ),
        ),
        duration: _duration,
      );
      _items.remove(0);
      _items = List.generate(_items.length, (index) => index);
      if (!isExternalDeleted) {
        repo.deleteChatRoom(chatRoom.chatRoomId);
        setSelfDelete();
      }
      // _items.remove(index);
    }
  }

  void _onChatTap({
    required int index,
    required ChatRoomModel chatRoom,
    required UserProfileModel profile,
    required String chatRoomId,
  }) {
    //Map<String, String> state.params['chatId'] => {"chidId" : "$index"}
    //GoRoute가 갖고 있는 인스턴스에 String으로 전달. route에 정의되어 있다 => final chatId
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"chatRoomId": chatRoomId},
      extra: ChatDetailScreenArg(
        isFromChatList: true,
        profile: profile,
        chatRoom: chatRoom,
      ),
    );
    /*Navigator.push(
        context,z
        (MaterialPageRoute(
          builder: (context) => ChatDetailScreen(chatId: "$index"),
        ))); */
  }

  Widget _makeChatsTile(
    int index,
    UserProfileModel profile,
    ChatRoomModel chatRoom,
  ) {
    final userId = ref.read(authRepo).user!.uid;
    List<String> usersList = chatRoom.chatRoomId.split("000");
    // ignore: unused_local_variable
    late final String listenerId;
    if (usersList[0] == userId) {
      listenerId = usersList[1];
    } else {
      listenerId = usersList[0];
    }
    return ListTile(
      onLongPress: () {
        _deleteItem(
          index,
          profile,
          chatRoom,
          false,
        );
      },
      //리스트타일이 문자 그대로 리스트의 모든 아이템에 똑같이 적용되기 때문에
      //UniqueKey를 추가해준다.
      //그러면 플러터가 헷갈리지 않을 거고, 애니메이션도 헷갈리지 않는다.
      onTap: () {
        _onChatTap(
          index: index,
          chatRoom: chatRoom,
          profile: profile,
          chatRoomId: chatRoom.chatRoomId,
        );
      },
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-qwer.appspot.com/o/avatars%2F${chatRoom.listenerId}?alt=media",
        ),
        child: Text(
          chatRoom.listenerName!,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chatRoom.listenerId != userId
                ? "with ${chatRoom.listenerName}"
                : "with me",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            chatRoom.lastStamp == null
                ? ""
                : convertTimeStamp(chatRoom.lastStamp!),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Text(
        chatRoom.lastMessage ?? "",
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _makeUserListTile({
    required int index,
    required UserProfileModel profile,
    ChatRoomModel? chatRoom,
  }) {
    chatRoom ??= ChatRoomModel.isEmpty();
    final chatListView = ref.read(chatRoomListProvider.notifier);
    final user = ref.read(authRepo).user;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.size28,
      ),
      child: ListTile(
        onLongPress: () {},
        //리스트타일이 문자 그대로 리스트의 모든 아이템에 똑같이 적용되기 때문에
        //UniqueKey를 추가해준다.
        //그러면 플러터가 헷갈리지 않을 거고, 애니메이션도 헷갈리지 않는다.
        onTap: () async {
          final results = await chatListView.onRequstingChats(
            senderId: user!.uid,
            receiverId: profile.uid,
          );
          final chatRoomId = results["chatRoomId"];
          final isExisting = results["isExisting"];
          if (!isExisting) {
            _items.add(0);
            _key.currentState!.insertItem(
              0,
              duration: _duration,
            );
          }
          _items = List.generate(_items.length, (index) => index);
          // ignore: use_build_context_synchronously
          context.pushNamed(
            ChatDetailScreen.routeName,
            params: {"chatRoomId": chatRoomId},
            extra: ChatDetailScreenArg(
              isFromChatList: false,
              profile: profile,
              chatRoom: chatRoom!,
            ),
          );
        },
        leading: CircleAvatar(
          radius: 30,
          foregroundImage: profile.hasAvater
              ? NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-qwer.appspot.com/o/avatars%2F${profile.uid}?alt=media",
                )
              : null,
          child: Text(
            profile.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              profile.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Text(
          profile.bio,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(chatRoomProfileProvider).when(
          data: (chatRooms) {
            return ref.watch(userListProvider).when(
                  data: (userList) {
                    final totalLength = chatRooms.length + userList.length;
                    initTotalLength > totalLength && !isSelfDelete
                        ? _deleteItem(0, UserProfileModel.empty(),
                            ChatRoomModel.isEmpty(), true)
                        : null;
                    isSelfDelete = false;
                    initTotalLength = totalLength;
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text(
                          "Direct message",
                        ),
                        elevation: 1,
                        actions: [
                          IconButton(
                            onPressed: () => totalLength == _items.length
                                ? {}
                                : _addItem(
                                    chatRoomsLength: chatRooms.length,
                                    userListLength: userList.length,
                                  ),
                            icon: const FaIcon(
                              FontAwesomeIcons.plus,
                            ),
                          ),
                        ],
                      ),
                      body: AnimatedList(
                        initialItemCount: chatRooms.length,
                        key: _key,
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size10,
                        ),
                        itemBuilder: (context, index, animation) {
                          final userListIndex = index - chatRooms.length;
                          return FadeTransition(
                            key: UniqueKey(),
                            //페이스트렌지션의 오파시티는 Animation<double>가 필요하다.
                            //마침 AnimatedList에서 해당 스타일의 animation을 제공해준다.
                            opacity: animation,
                            child: SizeTransition(
                              sizeFactor: animation,
                              child: chatRooms.length <= index
                                  ? _makeUserListTile(
                                      index: index,
                                      profile: userList[userListIndex],
                                    )
                                  : _makeChatsTile(
                                      index,
                                      userList[index],
                                      chatRooms[index],
                                    ),
                            ),
                          );
                        },
                      ),
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
        );
  }
}
