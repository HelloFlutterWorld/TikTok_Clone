import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  // 사용자가 로그인 했을 때 인증된 사용자의 id를 알 수 있도록 하기 위하여
  // 근데 ref.read(authRepo)를 바로 사용해도 될 듯?
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    // 이렇게 하면 createProfile이 있는 레포지토리를 호출할 수 있게 된다.
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      // database의 data를 이용해, <UsersViewModel>을 초기화한다.
      final profile = await _usersRepository
          .findProfile(_authenticationRepository.user!.uid);
      // database로부터 받아온 profile은 json형식이다.
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }
    // 우선 유저가 계정이 없고, 새로 만들어야 하는 경우, 데이터베이스에 프로파일이 없는 상태에서
    // 빈 프로파일을 반환한다.
    return UserProfileModel.empty();
  }

  Future<void> createProfile({
    required UserCredential credential,
    required String name,
    required String email,
    required String birthday,
  }) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    // 아래의 일들이 일어나는 동안 loading 해준다.
    // 유저가 빠르게 profile 페이지로 가는 것을 대비하기 위함도 있다.
    state = const AsyncValue.loading();

    // state를 초기화 하기 위해 UserProfileModel의 임시 객체를 만든다.
    final profile = UserProfileModel(
      hasAvater: false,
      bio: "undefined",
      link: "undefined",
      email: credential.user!.email ?? email,
      // 여기서 받아온 uid가 _usersRepository.createProfile에서 사용된다.
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? name,
      birthday: birthday,
    );
    await _usersRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  // AvatarViewModel에서는 이미지를 업로드하고 로딩 상태를 보여주고 있을 뿐
  // UserProfileScree의 전제화면에 데이터를 재공해주고 있지 않다.
  // 따라서 UserViewModel인 이 곳에서 아래의 메소드를 통해
  // 아바타가 업로드 되었음을 알려주어야 한다.
  Future<void> onAvatarUpload() async {
    // build 메소드가 초기화를 못한 경우를 가정, 하지만 그럴일 없음
    if (state.value == null) return;
    // state에 hasAvater: true를 추가하여 초기화해주고
    // state는 개별 필드만 업데이트 할 수는 없기 때문에, 전체를 다시 초기화해줌
    state = AsyncValue.data(state.value!.copyWith(hasAvater: true));
    // build메소드에서 UserProfileModel을 리턴받아오는 걸 모르기 때문에
    // 여가서는 nullable이다.
    // 데이터버이스에 "hasAvatar": true를 업데이트 해줌, 데이터베이스는 개별필드만 업데이트 가능
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<void> updateProfile({String? bio, String? link}) async {
    if (state.value == null) return;

    if (bio != null) {
      state = AsyncValue.data(state.value!.copyWith(bio: bio));
      await _usersRepository.updateUser(state.value!.uid, {"bio": bio});
    }
    if (link != null) {
      state = AsyncValue.data(state.value!.copyWith(link: link));
      await _usersRepository.updateUser(state.value!.uid, {"link": link});
    }
  }
}
// }

//UsersViewModel 클래스를 감싸는 AsyncNotifierProvider의 객체다
final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);

// AsyncValue는 비동기 데이터의 상태를 다루는 데에 중점을 두며,
// Notifier는 상태 관리와 UI 업데이트를 위한 클래스라는 차이점이 있다.

final userListProvider = StreamProvider.autoDispose<List<UserProfileModel>>(
  (ref) {
    final db = FirebaseFirestore.instance;
    return db.collection("users").orderBy("name").snapshots().map(
          // event는 아직 다큐먼트화되기 전의 데이타
          // .docs를 통해 다큐먼트리스트가 된다.
          (event) => event.docs
              // .map는 순환하면서 원소들을 doc라는 이름으로 제공한다.
              .map(
                (doc) => UserProfileModel.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  },
);
