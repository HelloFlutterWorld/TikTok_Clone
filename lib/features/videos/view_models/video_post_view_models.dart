import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<void, String> {
  late final VideoRepository _repository;
  late final String _videoId;

  @override
  FutureOr<void> build(String arg) async {
    _videoId = arg;
    _repository = ref.read(videoRepo);
  }

  Future<void> likeVideo() async {
    final user = ref.read(authRepo).user;
    await _repository.likeVideo(_videoId, user!.uid);
  }

  Future<bool> isLikedVideo() async {
    final user = ref.read(authRepo).user;
    return _repository.isLikedVideo(_videoId, user!.uid);
  }
}

final videoPostProvider =
    // 관리하는 모델은 void, 전달 받는 변수는 String
    AsyncNotifierProvider.family<VideoPostViewModel, void, String>(
  () => VideoPostViewModel(),
);
