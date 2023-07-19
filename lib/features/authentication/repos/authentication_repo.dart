import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  // 이렇게 인스턴스를 생성하는 선언만으로 firebase와 직접적인 소통이 가능하다.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null;
  // firebaseAuth에 어디에서든 쓸 수 있는 instance를 받아온 후,
  // 여기서 currentUser값을 받아오는 것이다.
  User? get user => _firebaseAuth.currentUser;

  // Future로 초기화만 하고 그 값이 따로 반환되어 사용되어지지 않을 때
  // Future<void>를 사용한다.
  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
/* 이렇게 바꿔줘도 문제 없음
  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
   */
}

// 일반 Provider은 제네릭이 한개 짜리다 Provider<AuthenticationRepository> authRepo
final authRepo = Provider((ref) => AuthenticationRepository());
