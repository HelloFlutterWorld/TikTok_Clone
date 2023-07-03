import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';

import 'chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  static const String routeName = "chats";
  static const String routeURL = "/chats";
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<int> _items = [];

  //AnimatedListState에 접근할 수 있는 key
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final Duration _duration = const Duration(milliseconds: 300);

  void _addItem() {
    if (_key.currentState != null) {
      //위에서부터(처음부터) 나타나게 하려면
      //_key.currentState!.insertItem(0);
      //아이템을 넣을 위치 0은 맨 처음이다.
      //왜냐면 initialItemCount: 0으로 세팅되어 있기 때문이다.
      _key.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
    }
  }

  void _deleteItem(int index) {
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
          child: Container(
            color: Colors.red,
            child: _makeTile(index),
          ),
        ),
        duration: _duration,
      );
      _items.remove(index);
    }
    //중간에 있는 리스트를 없앨 경우, 에러가 나기 때문에, 아래와 같이 _items를 재정렬해준다.
    _items = List.generate(_items.length, (index) => index);
  }

  void _onChatTap(int index) {
    //Map<String, String> state.params['chatId'] => {"chidId" : "$index"}
    //GoRoute가 갖고 있는 인스턴스에 String으로 전달. route에 정의되어 있다 => final chatId
    context.pushNamed(ChatDetailScreen.routeName, params: {"chatId": "$index"});
    //context.go('chatId/$index');
    /*Navigator.push(
        context,
        (MaterialPageRoute(
          builder: (context) => ChatDetailScreen(chatId: "$index"),
        ))); */
  }

  Widget _makeTile(int index) {
    return ListTile(
      onLongPress: () {
        _deleteItem(index);
      },
      //리스트타일이 문자 그대로 리스트의 모든 아이템에 똑같이 적용되기 때문에
      //UniqueKey를 추가해준다.
      //그러면 플러터가 헷갈리지 않을 거고, 애니메이션도 헷갈리지 않는다.
      onTap: () => _onChatTap(index),
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://avatars.githubusercontent.com/u/123614459?v=4",
        ),
        child: Text(
          "Yoon",
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Yoon ($index)",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "2:16 PM",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: const Text(
        "Don't forget to make video",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Direct message",
        ),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ],
      ),
      body: AnimatedList(
        key: _key,
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size10,
        ),
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            key: UniqueKey(),
            //페이스트렌지션의 오파시티는 Animation<double>가 필요하다.
            //마침 AnimatedList에서 해당 스타일의 animation을 제공해준다.
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: _makeTile(index),
            ),
          );
        },
      ),
    );
  }
}
