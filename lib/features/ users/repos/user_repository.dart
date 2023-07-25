import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/%20users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // create profile
  Future<void> createProfile(UserProfileModel profile) async {
    // collection은 폴더 같은 것이다.
    // users라는 컬렉션으로 간다.
    // 이 document는 authentificatoin에 있는 id를 path로 가질 것이다.
    // 모든 유저는 firebase로부터 id를 부여받는다.
    // users/id/{data}
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  // get profile
  // update profile
}

final userRepo = Provider((ref) => UserRepository());
