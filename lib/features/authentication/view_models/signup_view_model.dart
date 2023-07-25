import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/%20users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/utils.dart';

// AsyncNotifier<State> 제네릭이다.
// 노출할 데이터를 만들지 않는다. 왜냐하면, 이 viewmode은 계정을 만들 때
// 로딩화면을 보여주고, 계정생성을 트리거할 뿐이기 때문이다.
// 따라서 로딩 여부 말고는 필요한 value가 없다.
class SignupViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    // SignupViewModel도 인증 저장소에 대한 접근권한이 필요한데,
    // 이미 만들어 놓은 Provider(authRepo)가 있으므로 갖다가 쓴다.
    // 이렇게 함으로써 SignupViewModel은 AuthenticationRepository의 기능을 사용할 수 있게 된다.
    // 반드시 초기화 해주어야 한다.
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(BuildContext context) async {
    // 사람들에게 로딩중인 것을 알려줘야 함으로 async 사용한다.
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    final users = ref.read(usersProvider.notifier);
    // await _authRepo.signUp(form["email"], form["password"]);
    // 아무것도 expose하고 있지 않음으로 null값 세팅한다.
    // state = const AsyncValue.data(null);

    // guard에 Future function을 보내면 try catch로 에러를 포착한 후
    // 문제가 생기면 state에 에러가 들어오고,
    // 문제가 없다면 future 함수의 결과 데이터가 들어온다.
    // _authRepo.signUp는 Future<void>를 반환하므로
    // 아무 문제가 없다면 [state = const AsyncValue.data(null);]와 동일하다.
    state = await AsyncValue.guard(
      () async {
        // 계정을 생성하기 위해 authentification repo를 호출한다.
        final userCredential = await _authRepo.emailSignUp(
          form["email"],
          form["password"],
        );
        await users.createProfile(
          credential: userCredential,
          name: form["name"],
          email: form["email"],
          birthday: form["birthday"],
        );
      },
    );
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.goNamed(InterestsScreen.routeName);
    }
  }
}

// StateProvider는 바깥에서 수정할 수 있는 value를 expose하게 해준다.
// value를 expose해주면, 바깥에서 수정할 수 있는 것이다.
// 간단한 map을 expose하고 화면에서 이 vlaue를 수정한다.
// StateProvider는 클래스의 데이터를 상태로 직접적으로 관리하는 것이 아니라,
// 클래스의 데이터를 나타내는 상태 값을 제공하는 Provider의 역할을 한다.
final signUpForm = StateProvider((ref) => {});
// expose: SignupViewModel, data: void
final signUpProvider =
    AsyncNotifierProvider<SignupViewModel, void>(() => SignupViewModel());
