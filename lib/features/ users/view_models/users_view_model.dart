import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/%20users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/%20users/repos/user_repository.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;

  @override
  FutureOr<UserProfileModel> build() {
    // 이렇게 하면 createProfile이 있는 레포지토리를 호출할 수 있게 된다.
    _repository = ref.read(userRepo);
    // 우선 유저가 계정이 없고, 새로 만들어야 하는 경우만 가정해서 만듦
    // 즉 데이터베이스에 프로파일이 없는 상태다.
    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    // 아래의 일들이 일어나는 동안 loading 해준다.
    // 유저가 빠르게 profile 페이지로 가는 것을 대비하기 위함도 있다.
    state = const AsyncValue.loading();

    // AsyncValue<UserProfileModel>은 UserProfileModel 객체로 간주할 수 있다
    // 이 객체는 비동기적인 성격을 가지고 있으며, UserProfileModel의 데이터를 얻기 위해서는
    // 비동기적인 처리나 AsyncValue의 관련 메서드를 사용해야 하므로
    // UserProfileModel 객체를 AsyncValue<UserProfileModel> 타입으로 감싸서 반환한다.
    // 만들어진 모델클래스가 state에 노출될 것이다. 스크린은 이걸 사용할 수 있다.
    final profile = UserProfileModel(
      bio: "undefined",
      link: "undefined",
      email: credential.user!.email ?? "anon@anon.com",
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? "Anon",
    );
    await _repository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}

//UsersViewModel 클래스를 감싸는 AsyncNotifierProvider의 객체다
final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);


// AsyncValue는 비동기 데이터의 상태를 다루는 데에 중점을 두며, 
// Notifier는 상태 관리와 UI 업데이트를 위한 클래스라는 차이점이 있다.