import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  // 유저프로파일 생성과 업데이트를 위한 인스턴스 생성
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // 아바타 업로드와 업데이트를 위한 인스턴스 생성
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // create profile
  Future<void> createProfile(UserProfileModel profile) async {
    // collection은 폴더 같은 것이다.
    // users라는 컬렉션으로 간다.
    // 이 document는 firebase의 authentificatoin에 있는 id를 path로 가질 것이다.
    // 모든 유저는 firebase로부터 id를 부여받는다.
    // users/id/{data}
    // 여기서 받아온 profile은 createProfile되어지는 것이다.
    // 따라서 usersProvider에서 관리하는 데이터와 동일한 객체를 참조한다.
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  // get profile
  // 값이 있을 수도 없을 수도 있으니 nullable
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  // update profile
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  // update Avatar
  Future<void> uploadAvatar(File file, String fileName) async {
    // Firebase storage에서 많은 것들은 Reference라는 것으로 작동한다.
    // 이 것은 앱과 firebase storage 안의 폴더와의 link 같은 것이다.
    // 파일을 만들 때도 그에 대한 Reference를 갖게 된다.
    // Reference = Reference(app: [DEFAULT], fullPath: avatars/OMBbSYdlkiPq4UWewm7l8zYYQV92)
    // child("avatars/$fileName") 저장하고 싶은 경로를 적어준다.
    // ref()는 Firebase Storage 그 자체를 의미한다. 그 이후에 child가 하위폴더처럼 붙는다.
    final fileRef = _storage.ref().child("avatars/$fileName");
    await fileRef.putFile(file);
  }

  // update bio
  // update link or update bio & link
}

final userRepo = Provider((ref) => UserRepository());
