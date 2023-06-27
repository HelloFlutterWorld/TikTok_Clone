import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/video_preview_screen.dart';
import 'package:tiktok_clone/features/videos/widgets/camera_flash_button.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
//Ticker가 두 개 이상이 되었다.
    with
        TickerProviderStateMixin {
  bool _hasPermission = false;

  bool _deniedPermissions = false;

  bool _isSelfieMode = false;

  //late XFile video;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    /* value: 1.0,
    lowerBound: 1.0,
    upperBound: 1.3, */
  );

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final Animation<double> _buttonAnimation =
      //Tween을 _animationController와 결합하여 _buttonAnimation을 만듭니다.
      //이렇게 함으로써 _buttonAnimation은 _animationController를 기반으로하는 1.0에서 1.3 사이의 값을 가지게 됩니다.
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);

  late FlashMode _flashMode;

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
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    //IOS만을 위한 코드
    await _cameraController.prepareForVideoRecording();

    //처음엔  FlashMode.auto 로 초기회되어있음
    _flashMode = _cameraController.value.flashMode;
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
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _stopRecording();
    });
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails _) async {
    //안전을 위한 코드, 녹화중인데 또 녹화하면 안됨으로
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    //안전을 위한 코드, 녹화중이 아닌데 녹화를 중지하면 안됨으로
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();
    final video = await _cameraController.stopVideoRecording();
    /* try {
      video = await _cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      // 카메라 중지 중에 예외가 발생한 경우 수행할 작업
      if (kDebugMode) {
        print('Camera Exception: ${e.description}');
      }
      if (kDebugMode) {
        print('Camera Exception Code: ${e.code}');
      }
      initState();
    } */

    //final picture = await _cameraController.takePicture();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _progressAnimationController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _onPickVideoPressed() async {
    //갤러리에서 선택한 영상을 매게변수로 전달하면서 route해줌
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                          //사용자가 거부한 권한항목들이 남아있다.
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CameraPreview(_cameraController),
                    ),
                    Positioned(
                      top: Sizes.size20,
                      right: Sizes.size20,
                      child: Column(
                        children: [
                          IconButton(
                            color: Colors.white,
                            onPressed: _toggleSelfieMode,
                            icon: const Icon(
                              Icons.cameraswitch,
                            ),
                          ),
                          Gaps.v10,
                          CameraFlashButton(
                            flashMode: _flashMode,
                            targetMode: FlashMode.off,
                            setFlashMode: _setFlashMode,
                            icon: Icons.flash_off_rounded,
                          ),
                          Gaps.v10,
                          CameraFlashButton(
                            flashMode: _flashMode,
                            targetMode: FlashMode.always,
                            setFlashMode: _setFlashMode,
                            icon: Icons.flash_on_rounded,
                          ),
                          Gaps.v10,
                          CameraFlashButton(
                            flashMode: _flashMode,
                            targetMode: FlashMode.auto,
                            setFlashMode: _setFlashMode,
                            icon: Icons.flash_auto_rounded,
                          ),
                          Gaps.v10,
                          CameraFlashButton(
                            flashMode: _flashMode,
                            targetMode: FlashMode.torch,
                            setFlashMode: _setFlashMode,
                            icon: Icons.flashlight_on_rounded,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: Sizes.size40,
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTapDown: _startRecording,
                            //TapUpDetailsd없이 stopRecording를 호출
                            onTapUp: (details) => _stopRecording(),
                            child: ScaleTransition(
                              scale: _buttonAnimation,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: Sizes.size80 + Sizes.size14,
                                    height: Sizes.size80 + Sizes.size14,
                                    child: CircularProgressIndicator(
                                      color: Colors.red.shade400,
                                      strokeWidth: Sizes.size6,
                                      value: _progressAnimationController.value,
                                    ),
                                  ),
                                  Container(
                                    width: Sizes.size80,
                                    height: Sizes.size80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: _onPickVideoPressed,
                                icon: const FaIcon(
                                  FontAwesomeIcons.image,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
