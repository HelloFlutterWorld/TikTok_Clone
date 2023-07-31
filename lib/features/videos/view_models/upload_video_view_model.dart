import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideoRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videoRepo);
  }

  Future<void> uploadVideo(File video) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final task = await _repository.uploadVideoFile(video, user!.uid);
      // UploadTask가 완료되면 metadata를 볼 수 있다. 어떤 파일이 생성되었는지 알 수 있다.
      if (task.metadata != null) {
        await _repository.saveVideo();
      }
    });
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
