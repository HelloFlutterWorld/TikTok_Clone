import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UserRepository _userRepo = UserRepository();

  Future<void> sendMessage({
    required MessageModel message,
    required String chatRoomId,
    required String userId,
  }) async {
    // 새로운 문서를 생성하고 해당 문서의 참조를 가져옴
    final newMessageRef =
        _db.collection("chat_rooms").doc(chatRoomId).collection("texts").doc();

    // 메시지에 새로운 문서의 ID를 추가
    final updatedMessage = {...message.toJson(), "messageId": newMessageRef.id};

    // 새로운 문서에 메시지를 추가
    await newMessageRef.set(updatedMessage);

    // await _db.collection("chat_rooms").doc(chatRoomId).collection("texts").add(
    //       message.toJson(),
    //     );
    List<String> users = chatRoomId.split("000");
    String myId, listenerId;
    if (userId == users[0]) {
      myId = users[0];
      listenerId = users[1];
    } else {
      myId = users[1];
      listenerId = users[0];
    }
    await _db
        .collection("users")
        .doc(myId)
        .collection("myChatRooms")
        .doc(chatRoomId)
        .update({
      "lastStamp": message.createdAt,
      "lastMessage": message.text,
    });
    await _db
        .collection("users")
        .doc(listenerId)
        .collection("myChatRooms")
        .doc(chatRoomId)
        .update({
      "lastStamp": message.createdAt,
      "lastMessage": message.text,
    });
  }

  Future<Map<String, dynamic>> createChatsRoom({
    required String personA,
    required String personB,
  }) async {
    final query = _db.collection("chat_rooms").doc("${personA}000$personB");

    final profileOfPersonA = await _userRepo.findProfile(personA);
    final profileOfPersonB = await _userRepo.findProfile(personB);

    final nameOfPersonA = profileOfPersonA?["name"];
    final hasAvatarOfA = profileOfPersonA?["hasAvatar"];
    final bioOfA = profileOfPersonA?["bio"];

    final nameOfPersonB = profileOfPersonB?["name"];
    final hasAvatarOfB = profileOfPersonB?["hasAvatar"];
    final bioOfB = profileOfPersonB?["bio"];

    final chatroom = await query.get();

    if (chatroom.exists) {
      return {
        "chatRoomId": chatroom.id,
        "isExisting": true,
      };
    } else {
      await query.set(
        {
          "personA": personA,
          "personB": personB,
        },
      );

      final myChatRoomQueryA = _db
          .collection("users")
          .doc(personA)
          .collection("myChatRooms")
          .doc("${personA}000$personB");

      final myChatRoomQueryB = _db
          .collection("users")
          .doc(personB)
          .collection("myChatRooms")
          .doc("${personA}000$personB");

      await myChatRoomQueryA.set({
        "chatRoomId": "${personA}000$personB",
        "listenerName": nameOfPersonB,
        "listenerId": personB,
        "hasAvatar": hasAvatarOfB,
        "bio": bioOfB,
      });

      await myChatRoomQueryB.set({
        "chatRoomId": "${personA}000$personB",
        "listenerName": nameOfPersonA,
        "listenerId": personA,
        "hasAvatar": hasAvatarOfA,
        "bio": bioOfA,
      });

      return {
        "chatRoomId": query.id,
        "isExisting": false,
      };
    }
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    final query = _db.collection("chat_rooms").doc(chatRoomId);
    query.delete();
  }

  Future<void> deleteMessage(
    String chatRoomId,
    String messageId,
  ) async {
    final query = _db
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("texts")
        .doc(messageId);
    await query.update({"text": "[deleted]"});
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
