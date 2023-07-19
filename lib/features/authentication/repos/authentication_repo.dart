import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  // 이렇게 인스턴스를 생성하는 선언만으로 firebase와 직접적인 소통이 가능하다.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null;
  // firebaseAuth에 어디에서든 쓸 수 있는 instance를 받아온 후,
  // 여기서 currentUser값을 받아오는 것이다.
  User? get user => _firebaseAuth.currentUser;
}

// 일반 Provider은 제네릭이 한개 짜리다 Provider<AuthenticationRepository> authRepo
final authRepo = Provider((ref) => AuthenticationRepository());
