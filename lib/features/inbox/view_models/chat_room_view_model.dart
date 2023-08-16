import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';

class ChatRoomListViewModel extends AsyncNotifier<void> {
  late final MessagesRepo _repo;
  @override
  FutureOr<void> build() async {
    _repo = await ref.read(messagesRepo);
  }

  Future<Map<String, dynamic>> onRequstingChats({
    required String senderId,
    required String receiverId,
  }) async {
    List<String> list = [senderId, receiverId];
    list.sort();
    return await _repo.createChatsRoom(personA: list[0], personB: list[1]);
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    await _repo.deleteChatRoom(chatRoomId);
  }
}

final chatRoomListProvider = AsyncNotifierProvider<ChatRoomListViewModel, void>(
  () => ChatRoomListViewModel(),
);

final chatRoomProfileProvider = StreamProvider.autoDispose<List<ChatRoomModel>>(
  (ref) {
    final db = FirebaseFirestore.instance;
    final user = ref.read(authRepo).user;
    return db
        .collection("users")
        .doc(user!.uid)
        .collection("myChatRooms")
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (doc) => ChatRoomModel.formJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  },
);
