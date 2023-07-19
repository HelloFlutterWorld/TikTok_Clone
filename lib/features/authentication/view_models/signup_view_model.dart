import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

// AsyncNotifier<State> 제네릭이다.
// 노출할 데이터를 만들지 않는다. 왜냐하면, 이 viewmode은 계정을 만들 때
// 로딩화면을 보여주고, 계정생성을 트리거할 뿐이기 때문이다.
// 따라서 로딩 여부 말고는 필요한 value가 없다.
class SignupViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp() async {
    // 사람들에게 로딩중인 것을 알려줘야 함으로 async 사용한다.
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);

    // await _authRepo.signUp(form["email"], form["password"]);
    // 아무것도 expose하고 있지 않음으로 null값 세팅한다.
    // state = const AsyncValue.data(null);

    // guard에 Future function을 보내면 try catch로 에러를 포착한 후
    // 문제가 생기면 state에 에러가 들어오고,
    // 문제가 없다면 future 함수의 결과 데이터가 들어온다.
    // _authRepo.signUp는 Future<void>를 반환하므로
    // 아무 문제가 없다면 [state = const AsyncValue.data(null);]와 동일하다.
    state = await AsyncValue.guard(
      () async => await _authRepo.signUp(
        form["email"],
        form["password"],
      ),
    );
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
