import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class AvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepo);
  }

  // 사용자가 이  view model을 호출했다는 건, 로그인한 상태를 의미하기에
  // user(currentUser)는 반드시 존재하는 상태다.
  Future<void> uploadAvatar(File file) async {
    // avatarViewModel만 따로 로딩상태 만들어줌
    // 그래야 UserProfileScreen의 전체화면 로딩을 막아줌
    state = const AsyncValue.loading();
    final fileName = ref.read(authRepo).user!.uid;
    state = await AsyncValue.guard(() async {
      // 아바타를 스토리지에 업로드하고
      await _repository.uploadAvatar(file, fileName);
      // UserViewModel에게 현재 아바타가 있음을 아래의 호출로 알려준다.
      // 1, userViewModel의 state 정리
      // state = AsyncValue.data(state.value!.copyWith(hasAvater: true));
      // 2, 아래의 두 줄로 fireStore의 항목 업데이트
      // await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
      // await _db.collection("users").doc(uid).update(data);
      // 위의 세줄의 코드가 차례로 실행되어 업로드 완성
      await ref.read(usersProvider.notifier).onAvatarUpload();
    });
  }
}

final avatarProvider = AsyncNotifierProvider<AvatarViewModel, void>(
  () => AvatarViewModel(),
);
