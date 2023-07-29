import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/features/users/view_models/avatar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final bool hasAvatar;
  final String uid;

  const Avatar({
    super.key,
    required this.name,
    required this.hasAvatar,
    required this.uid,
  });

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (xFile != null) {
      final file = File(xFile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 오직 avatarViewModel의 로딩이다. 따라서 전체화면이 로딩되지 않는다.
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundImage: hasAvatar
                  // 이미지 캐싱은 이미지를 한 번 다운로드한 후에 로컬 장치(예: 스마트폰, 컴퓨터)에 저장하여
                  // 나중에 동일한 이미지가 필요할 때 다시 다운로드하지 않고 빠르게 불러올 수 있게 하는 기술
                  // 따라서 동일한 파일명이지만 이미지의 내용이 다른 경우 이를 방지하기 위해
                  // &haha=${DateTime.now().toString()}"를 추가해준다.
                  ? NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-qwer.appspot.com/o/avatars%2F$uid?alt=media&haha=${DateTime.now().toString()}")
                  : null,
              child: Text(name),
            ),
    );
  }
}
