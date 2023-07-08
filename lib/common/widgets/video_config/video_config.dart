import 'package:flutter/widgets.dart';

/* class VideoConfigData extends InheritedWidget {
  //InheritedWidget은 다시 빌드하지 않는 이상, 인스턴스들을 수정할 수 없다.

  final bool autoMute;
  final void Function() toggleMuted;
  //if final void Function => onPressed: () => VideoConfigData.of(context).toggleMuted(),

  const VideoConfigData({
    super.key,
    required this.toggleMuted,
    required this.autoMute,
    required super.child,
  });

  static VideoConfigData of(BuildContext context) {
    // 현재 위젯의 위치 및 구성에 대한 정보를 제공하는 BuildContext는
    // 현재 위젯의 상위 위젯을 탐색하거나, 위젯 트리에 있는 다른 위젯과 상호 작용할 수 있다
    // dependOnInheritedWidgetOfExactType 메서드는 BuildContext에서 정확히 지정된 타입
    // (VideoConfigData)의 InheritedWidget을 찾는다
    // 즉 이미 위젯트리에 추가되어 있는 VideoConfigData를 찾아준다.
    // 이 메서드는 찾은 InheritedWidget의 인스턴스를 반환하거나,
    // 해당 타입의 InheritedWidget이 없을 경우 null을 반환한다.
    // null을 반환하는 경우가 없다고 가정하고, !를 사용하여 null이 아님을 보장한다.
    return context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class VideoConfig extends StatefulWidget {
  final Widget child;
  const VideoConfig({
    super.key,
    required this.child,
  });

  @override
  State<VideoConfig> createState() => _VideoConfigState();
}

class _VideoConfigState extends State<VideoConfig> {
  bool autoMuted = false;

  void toggleMuted() {
    setState(() {
      autoMuted = !autoMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoConfigData(
      toggleMuted: toggleMuted,
      autoMute: autoMuted,
      child: widget.child,
    );
  }
}

//VideoConfig(child: MatreialApp) => 
//VideoConfigData(child: MaterialApp) & 데이터와 콜백함수 */

/* //ChangeNotifier는 데이터가 많을 때 유리하다.
//List나 메소드나 API 등
class VideoConfig extends ChangeNotifier {
  bool autoMute = false;
  
  bool get autoMute1 {
    return autoMute;
  }

  void toggleAutoMute() {
    autoMute = !autoMute;
    //구독이란 ChangeNotifier를 사용하여 해당 변수의 상태변화를
    //감지하는 것이다.
    //autoMute 정보를 구독하고 있는 다른 객체들에게 알려주는 역할을 한다.
    notifyListeners();
  }
}

final videoConfig = VideoConfig(); */

//ValueNotifier는 결국 하나의 값에 대한 ChangeNotifier다.
final videoConfig = ValueNotifier(false);
