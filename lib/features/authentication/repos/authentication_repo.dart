import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  // 이렇게 인스턴스를 생성하는 선언만으로 firebase와 직접적인 소통이 가능하다.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null;
  // firebaseAuth에 어디에서든 쓸 수 있는 instance를 받아온 후,
  // 여기서 currentUser값을 받아오는 것이다.
  User? get user => _firebaseAuth.currentUser;

  // Stream을 사용하면 유저의 인증상태가 바뀔 때만다 앱을 실시간으로 새로고침할 수 있다.
  // Stream은 실시간 연결 같은 것이다.
  // FirebaseAuth의 stream을 expose할 건데, 그 stream은 AuthStateChanges라고 한다.
  // 우선 Stream을 return 해준다. 유저가 있을지 없을지 모른다.
  // Notifies about changes to the user's sign-in state (such as sign-in or sign-out)
  Stream<User?> authStateChages() => _firebaseAuth.authStateChanges();

  // Future로 초기화만 하고 그 값이 따로 반환되어 사용되어지지 않을 때
  // Future<void>를 사용한다.
  Future<void> emailSignUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // 이론적으로 view(settingsScreen)는 repository와 직접 소통해선 안되고,
  // 반드시 viewModel을 거쳐아 하지만 간단한 코드이므로 무시하기로 한다.
  // 아래의 함수가 호출되어서 앱의 인증상태가 변경되면,
  // 아래의 stream이 그 변경을 감지(repo.authStateChages())하게 되고
  // 그러면 라우터가 리빌드 될 것이다. 왜냐면 라우터는 authRepo에 의존성이 있기 때문에
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

// 단순히 데이터만 노출하는 기본 프로바이더.
final authRepo = Provider((ref) => AuthenticationRepository());

// 이 프로바이더는 유저의 인증 상태 변경을 감지한다.
// 로그인, 로그아웃 상태인지 변화가 생기면 바로 알 수 있다.
// authState: 인증상태
final authState = StreamProvider((ref) {
  // AuthenticationRepository객체를 repo에 대입함
  final repo = ref.read(authRepo);
  // AuthenticationRepository객체의 인스턴스 메소드 호출
  // 유저의 인증상태를 점검하는 함수를 호출한다.
  return repo.authStateChages();
});
