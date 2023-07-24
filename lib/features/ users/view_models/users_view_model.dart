import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/%20users/models/user_profile_model.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  @override
  FutureOr<UserProfileModel> build() {
    // 우선 유저가 계정이 없고, 새로 만들어야 하는 경우만 가정해서 만듦
    // 즉 데이터베이스에 프로파일이 없는 상태다.
    return UserProfileModel.empty();
  }

  Future<void> createAccount(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    // AsyncValue<UserProfileModel>은 UserProfileModel 객체로 간주할 수 있다
    // 이 객체는 비동기적인 성격을 가지고 있으며, UserProfileModel의 데이터를 얻기 위해서는
    // 비동기적인 처리나 AsyncValue의 관련 메서드를 사용해야 하므로
    // UserProfileModel 객체를 AsyncValue<UserProfileModel> 타입으로 감싸서 반환한다.

    state = AsyncValue.data(
      UserProfileModel(
        bio: "undefined",
        link: "undefined",
        email: credential.user!.email ?? "anon@anon.com",
        uid: credential.user!.uid,
        name: credential.user!.displayName ?? "Anon",
      ),
    );
  }
}

//UsersViewModel 클래스를 감싸는 AsyncNotifierProvider의 객체다
final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);


// AsyncValue는 비동기 데이터의 상태를 다루는 데에 중점을 두며, 
// Notifier는 상태 관리와 UI 업데이트를 위한 클래스라는 차이점이 있다.