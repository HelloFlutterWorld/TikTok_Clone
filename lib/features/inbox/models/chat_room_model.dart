class ChatRoomModel {
  final String chatRoomId;
  final int? lastStamp;
  final String? lastMessage;
  final String? listenerId;
  final String? listenerName;
  final bool? hasAvatar;
  final String? bio;

  ChatRoomModel({
    required this.chatRoomId,
    required this.lastStamp,
    required this.lastMessage,
    required this.listenerId,
    required this.listenerName,
    required this.hasAvatar,
    required this.bio,
  });

  ChatRoomModel.isEmpty()
      : chatRoomId = "",
        lastStamp = 0,
        lastMessage = "",
        listenerId = "",
        listenerName = "",
        hasAvatar = false,
        bio = "";

  ChatRoomModel.formJson(
    Map<String, dynamic> json,
  )   : chatRoomId = json["chatRoomId"],
        lastStamp = json["lastStamp"],
        lastMessage = json["lastMessage"],
        listenerId = json["listenerId"],
        listenerName = json["listenerName"],
        hasAvatar = json["hasAvatar"],
        bio = json["bio"];
}
