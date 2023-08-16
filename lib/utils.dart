import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

void showFirebaseErrorSnack(
  BuildContext context,
  Object? error,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(
        (error as FirebaseException).message ?? "Something wen't wrong.",
      ),
    ),
  );
}

String convertTimeStamp(int timeStamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  String period = dateTime.hour >= 12 ? '오후' : '오전';
  int hour = dateTime.hour % 12;
  hour = hour == 0 ? 12 : hour; // 0 시를 12로 변경

  String formattedTime =
      "$period $hour:${dateTime.minute.toString().padLeft(2, '0')}";
  return formattedTime;
}

bool isWithin2Minutes(int createdAt) {
  final now = DateTime.now();
  final messageTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
  final difference = now.difference(messageTime);
  return difference.inMinutes <= 2;
}
