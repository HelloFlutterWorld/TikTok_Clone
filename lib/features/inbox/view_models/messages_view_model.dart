import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepo _repo;
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _repo = ref.read(messagesRepo);
    _authRepo = ref.read(authRepo);
  }

  Future<void> sendMessage({
    required String text,
    required String chatRoomId,
  }) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _repo.sendMessage(
        message: message,
        chatRoomId: chatRoomId,
        userId: _authRepo.user!.uid,
      );
    });
  }

  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    _repo.deleteMessage(chatRoomId, messageId);
  }
}

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

// autoDispose해야 채팅방을 나갔을 때는 listen을 하지 않게 된다.
final chatProvider =
    StreamProvider.autoDispose.family<List<MessageModel>, String>(
  (ref, chatRoomId) {
    final db = FirebaseFirestore.instance;
    return db
        // 처음 채팅이 시작될 때 이 채팅방의 texts콜렉션안의 모든
        // 도큐먼트들을 받을 것이고,
        // 새로 추가되는 것들도 listen하게 된다.
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("texts")
        .orderBy("createdAt")
        // 한번만 데이터들 받아오는 get()과 달리
        // snapshots는 실시간으로 데이터를 받아온다.
        // texts 콜렉션의 문서들을 createdAt 필드를 기준으로 정렬하여
        // 실시간으로 listen하여 snapshots()를 통해 가져온다.
        .snapshots()
        .map(
          // event는 아직 다큐먼트화되기 전의 데이타
          // .docs를 통해 다큐먼트리스트가 된다.
          (event) => event.docs
              // .map는 순환하면서 원소들을 doc라는 이름으로 제공한다.
              .map(
                (doc) => MessageModel.fromJson(
                  doc.data(),
                ),
              )
              .toList()
              .reversed
              .toList(),
        );
  },
);
