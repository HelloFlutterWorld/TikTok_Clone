import 'dart:async';
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
            "videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}");
    return fileRef.putFile(video);
  }

  // cread a video document
  Future<void> saveVideo(VideoModel data) async {
    // video의 id는 랜덤으로 형성된다.
    await _db.collection("videos").add(data.toJson());
  }

  // QuerySnapshot은 기본적으로 Map자료를 가지고 있다.
  // "페이징"은 데이터를 작은 페이지로 나누어 로드하는 기술 자체를 의미
  // "페이지네이션"은 페이징된 데이터를 사용자 인터페이스에서 표현하는 방식
  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos(
      {int? lastItemCreatedAt}) {
    //  return _db.collection("videos").where("likes", isGreaterThan: 10);
    final query = _db
        .collection("videos")
        .orderBy("createdAt",
            // 내림차순을 의미
            descending: true)
        // 영상 두 개가 한 페이지이다.
        .limit(2);
    if (lastItemCreatedAt == null) {
      // return query.get(); 구문은 Firestore 데이터베이스에서 해당 쿼리를 실행하고,
      // 결과로써 해당 쿼리에 일치하는 도큐먼트들의 스냅샷을 반환한다.
      // 스냅샷에는 각 도큐먼트의 데이터 뿐만 아니라 각 도큐먼트의 고유한 ID도 포함된다.
      return query.get();
    } else {
      // list로 넘겨주는 이유는 [lastItemCreatedAt, "likes", "creator"] 들
      // 다양한 옵션을 넣어서 정렬해줄 수 있기 때문이다.
      // 여기에서 넘겨주는 리스트는 oderBy로 정렬된 모든 것들의 필드이다.
      // lastItemCreatedAt부터 시작하여 정렬된다.
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<void> likeVideo(String videoId, String userId) async {
    final query = _db.collection("likes").doc("${videoId}000$userId");
    final like = await query.get();

    // 도큐먼트가 존재하지 않으면 true 반환
    if (!like.exists) {
      await query.set({
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      await query.delete();
    }
  }

  Future<bool> isLikedVideo(String videoId, String userId) async {
    final query = _db
        .collection("users")
        .doc(userId)
        .collection("likedVideos")
        .doc(videoId);
    final likeVideo = await query.get();
    return likeVideo.exists;
  }
}

final videoRepo = Provider((ref) => VideoRepository());
