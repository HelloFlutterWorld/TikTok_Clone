import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/upload_video_view_model.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  final XFile video;
  final bool isPicked;

  const VideoPreviewScreen({
    super.key,
    required this.video,
    required this.isPicked,
  });

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;

  bool _savedVideo = false;
  Map<String, String> formData = {};

  Future<void> _initVideo() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    //await _videoPlayerController.play();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _saveToGallery() async {
    if (_savedVideo) return;

    await GallerySaver.saveVideo(
      widget.video.path,
      albumName: "TikTok Clone",
    );

    _savedVideo = true;

    setState(() {});
  }

  void _onUploadPressed() {
    ref.read(uploadVideoProvider.notifier).uploadVideo(
          File(widget.video.path),
          context,
          formData,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview video'),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(
                _savedVideo
                    ? FontAwesomeIcons.check
                    : FontAwesomeIcons.download,
              ),
            ),
          IconButton(
            onPressed: ref.watch(uploadVideoProvider).isLoading
                // 로딩중일 때는 클릭해도 무쓸모
                ? () {}
                : _onUploadPressed,
            icon: ref.watch(uploadVideoProvider).isLoading
                ? const CircularProgressIndicator()
                : const FaIcon(
                    FontAwesomeIcons.cloudArrowUp,
                  ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned(
            bottom: 100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent.withOpacity(0.18),
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: "title",
                          hintStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        onChanged: (newValue) {
                          formData["title"] = newValue;
                        },
                      ),
                      Gaps.v4,
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: "description",
                          hintStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        onChanged: (newValue) {
                          formData["description"] = newValue;
                        },
                      ),
                      Gaps.v10,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
