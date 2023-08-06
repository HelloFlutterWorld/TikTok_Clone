import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideoRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // upload a video file
  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage
        .ref()
        // Unix epoch로부터 몇 밀리초가 지났는지를 나타낸다. 1970년 이후부터 지금까지의 숫자
        .child(
            "vidoes/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}");
    return fileRef.putFile(video);
  }

  // cread a video document
  Future<void> saveVideo(VideoModel data) async {
    // video의 id는 랜덤으로 형성된다.
    await _db.collection("videos").add(data.toJson());
  }

  // QuerySnapshot은 기본적으로 Map자료를 가지고 있다.
  Future<QuerySnapshot<Map<String, dynamic>>> fetchVidoes() {
    //  return _db.collection("videos").where("likes", isGreaterThan: 10);
    return _db
        .collection("videos")
        .orderBy("createdAt",
            // 내림차순을 의미
            descending: true)
        .get();
  }
}

final videoRepo = Provider((ref) => VideoRepository());
