/* import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_midel.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  final VideoPlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  late final PlaybackConfigMedel _model = PlaybackConfigMedel(
    // PlaybackConfigViewModel 객체가 위젯트리에 등록되는 순간
    // repository에 있는 데이터들을 가져와 model에 대입한다.
    muted: _repository.isMuted(),
    autoplay: _repository.isAutoplay(),
  );

  bool get muted => _model.muted;
  bool get autoplay => _model.autoplay;

  void setMuted(bool value) {
    // 1.데이터를 persist한다.
    _repository.setMuted(value);
    // 2.데이터를 수정한다.
    _model.muted = value;
    // 구독자에게 통보한다.
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    _model.autoplay = value;
    notifyListeners();
  }
} */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_midel.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';

// PlaybackConfigViewModel이
// <PlaybackConfigMedel>라는 stste를 관리할 수 있는 Notifier를 상속받는 개념
// Notifier 들은 state를 가질 것이고, 그 state 는 사용자에게 노출하고픈 데이터이다.

class PlaybackConfigViewModel extends Notifier<PlaybackConfigMedel> {
  final VideoPlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    // 1.데이터를 persist한다.
    _repository.setMuted(value);
    // 2.데이터를 수정한다.
    // Notifier 클래스의 state는 읽기 전용으로 간주되어 직접적인 값 변경이 허용되지 않음
    // state가 새로 만들어 질 때, build메소드가 reBuild되어 사용자 화면이 업데이트된다.
    state = PlaybackConfigMedel(
      muted: value,
      autoplay: state.autoplay,
    );
    // 3. 굳이 통보하지 않아도 build 메소드가 reBuild 되면서
    // view 화면의 데이터들은 업데이트 된다.
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigMedel(
      muted: state.muted,
      autoplay: value,
    );
  }

  // build 메소드는 Notifier가 노출하고 픈 데이터를 제공하는 방법이다.
  // 이 build 메소드가 가장 먼저 실행되어,
  // 초기화가 다 끝난 PlaybackConfigMedel 객체를 반환받는다.
  @override
  PlaybackConfigMedel build() {
    return PlaybackConfigMedel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
    );
  }
}

// playbackConfigProvider는
// PlaybackConfigViewModel 객체를 생성하고 해당 객체의 상태는
// <PlaybackConfigModel> 객체로 초기화며, 상태 변경에 따라 업데이트된다.
// NotifierProvider<NotifierT extends Notifier<T>, T>
final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigMedel>(
  // () => PlaybackConfigViewModel(_repository)를 만들 때 매개변수 _repository가 필요한데
  // SharedPreferences는 await 된 다음에 받아올 수 있다.
  // 이 일은 main에서 이뤄지기 때문에, 아래와 같이 예외처리를 해준다.
  // 다만 이 Provider를 사용하기 전에, 그리고 이 에러가 실제로 throw되기 전에,
  // main에서 override 해준다.
  // UnimplementedError는 개발자가 아직 해당 부분을 구현하지 않았음을 나타내는 예외다.
  () => throw UnimplementedError(),
);
