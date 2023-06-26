import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _hasPermission = false;
  bool _deniedPermissions = false;
  bool _isSelfieMode = false;

  late CameraController _cameraController;

  Future<void> initCamera() async {
    //사용가능한 카메라들을 반환
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }
    /*  print(cameras);
    //[CameraDescription(0, CameraLensDirection.back, 90), CameraDescription(1, CameraLensDirection.front, 270), CameraDescription(2, CameraLensDirection.back, 90), CameraDescription(3, CameraLensDirection.front, 270)] Lost connection to device */
    _cameraController = CameraController(
        //0: 후면, 1: 전면
        cameras[_isSelfieMode ? 1 : 0],
        ResolutionPreset.ultraHigh);

    await _cameraController.initialize();
  }

  //카메라, 마이크 권한 초기화
  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermisson = await Permission.microphone.request();

    final cameraDenide =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenide = micPermisson.isDenied || micPermisson.isPermanentlyDenied;

    if (!cameraDenide && !micDenide) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    } else {
      _deniedPermissions = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission || !_cameraController.value.isInitialized
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    !_deniedPermissions
                        ? "Initializing..."
                        : "The camera and microphone permissions are required.",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gaps.v20,
                  if (!_deniedPermissions)
                    const CircularProgressIndicator.adaptive(),
                  if (_deniedPermissions) ...[
                    Gaps.v96,
                    GestureDetector(
                      onTap: () async {
                        await openAppSettings();
                        initPermissions();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(Sizes.size8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Text(
                          "Device Permission Settings",
                          style: TextStyle(
                            fontSize: Sizes.size20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(_cameraController),
                  Positioned(
                    top: Sizes.size20,
                    left: Sizes.size20,
                    child: IconButton(
                      color: Colors.black,
                      onPressed: _toggleSelfieMode,
                      icon: const Icon(
                        Icons.cameraswitch,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
