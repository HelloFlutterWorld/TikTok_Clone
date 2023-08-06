import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideoRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videoRepo);
  }

  Future<void> uploadVideo(
    File video,
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () async {
          // video를 storage에 업로드하고
          final task = await _repository.uploadVideoFile(
            video,
            user!.uid,
          );
          // UploadTask가 완료되면 metadata를 볼 수 있다. 어떤 파일이 생성되었는지 알 수 있다.
          if (task.metadata != null) {
            // video의 data를 database에 초기화해준다.
            await _repository.saveVideo(
              VideoModel(
                title: data["title"] ?? "",
                description: data["description"] ?? "",
                fileUrl: await task.ref.getDownloadURL(),
                thumbnailUrl: "",
                creatorUid: user.uid,
                creator: userProfile.name,
                likes: 0,
                comments: 0,
                createdAt: DateTime.now().millisecondsSinceEpoch,
              ),
            );
            // 카메라화면으로 pop해주고
            context.pop();
            // 그 다음 사용자가 upload 버튼을 눌렀던 화면으로 다시 pop해준다.
            context.pop();
          }
        },
      );
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
