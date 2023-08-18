import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToket(String token) async {
    final user = ref.read(authRepo).user;
    await _db.collection("users").doc(user!.uid).update(
      {
        "token": token,
      },
    );
  }
/*
  요청에서 반환된 NotificationSettings 객체의 authorizationStatus 속성을 사용하여 사용자의 전체 결정을 확인할 수 있습니다.
  authorized: 사용자에게 권한이 부여되었습니다.
  denied: 사용자가 권한을 거부했습니다.
  notDetermined: 사용자가 아직 권한 부여 여부를 선택하지 않았습니다.
  provisional: 사용자에게 임시 권한이 부여됩니다.

  Foreground: 애플리케이션이 열려 있고 보기 상태이며 사용 중인 경우
  Backcround: 애플리케이션이 열려 있지만 백그라운드에 있는 경우(최소화). 이는 일반적으로 사용자가 기기에서 '홈' 버튼을 누르거나 앱 전환기를 사용하여 다른 앱으로 전환했거나 다른 탭(웹)에서 애플리케이션을 열어 둔 경우에 발생합니다.
  terminated: 기기가 잠겨 있거나 애플리케이션이 실행되고 있지 않은 경우.
*/

  Future<void> initListeners(BuildContext context) async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      // denied 상태면 바로 종료
      return;
    }
    // Foreground
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage event) {
        print("I just got a message and I'm in the foreground");
        print(event.notification?.title);
      },
    );
    // Background
    FirebaseMessaging.onMessageOpenedApp.listen(
      (notification) {
        // print(notification.data['screen'])
        context.pushNamed(ChatsScreen.routeName);
      },
    );
    // Terminated
    final notification = await _messaging.getInitialMessage();
    if (notification != null) {
      // print(notification.data['screen'])
      context.pushNamed(VideoRecordingScreen.routeName);
    }
  }

  @override
  FutureOr build(BuildContext context) async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await updateToket(token);
    await initListeners(context);
    // toke listener
    _messaging.onTokenRefresh.listen(
      (newToken) async {
        await updateToket(newToken);
      },
    );
  }
}

// 관리하는 모델은 없고, 전달 받는 매개변수도 없다.
final notificationsProvider = AsyncNotifierProvider.family(
  () => NotificationsProvider(),
);
