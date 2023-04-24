import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final List<int> _items = [];

  //AnimatedListState에 접근할 수 있는 key
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  void _addItem() {
    if (_key.currentState != null) {
      //위에서부터(처음부터) 나타나게 하려면
      //_key.currentState!.insertItem(0);
      //아이템을 넣을 위치 0은 맨 처음이다.
      //왜냐면 initialItemCount: 0으로 세팅되어 있기 때문이다.
      _key.currentState!.insertItem(
        _items.length,
        duration: const Duration(
          milliseconds: 500,
        ),
      );
      _items.add(_items.length);
    }
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
              child: ListTile(
                //리스트타일이 문자 그대로 리스트의 모든 아이템에 똑같이 적용되기 때문에
                //UniqueKey를 추가해준다.
                //그러면 플러터가 헷갈리지 않을 거고, 애니메이션도 헷갈리지 않는다.
                leading: const CircleAvatar(
                  radius: 30,
                  foregroundImage: NetworkImage(
                    "https://d1telmomo28umc.cloudfront.net/media/public/avatars/customs0529-1679985124.jpg",
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
                      "Lynn ($index)",
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
              ),
            ),
          );
        },
      ),
    );
  }
}
