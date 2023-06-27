import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final XFile video;

  const VideoPreviewScreen({
    super.key,
    required this.video,
  });

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;

  Future<void> _initVideo() async {
    //widget.video는 XFile class이고, name과 path를 가지고 있다.
    //우리가 원하는 것은 path다

    _videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );
    try {
      await _videoPlayerController.initialize();
    } on PlatformException catch (e) {
      // PlatformException 예외 처리
      if (e.code == 'VideoError') {
        // VideoError에 대한 처리
        if (kDebugMode) {
          print('Video Player Error: ${e.message}');
        }
      } else {
        // 다른 PlatformException에 대한 처리
        if (kDebugMode) {
          print('Platform Exception: ${e.message}');
        }
      }
    } catch (e) {
      // 기타 예외에 대한 처리
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();

    //_videoPlayerController가 초기회 된것을 build 메소드에 알려주어야 한다.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Preview Video"),
      ),
      body: _videoPlayerController.value.isInitialized
          ? VideoPlayer(_videoPlayerController)
          : null,
    );
  }
}
