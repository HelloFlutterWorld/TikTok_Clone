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

//playbackConfigProvider를 통해 PlaybackConfigViewModel 객체를 생성하고 해당 객체의 상태를 PlaybackConfigModel 객체로 초기화하는 구조입니다. 이렇게 생성된 PlaybackConfigModel 객체는 PlaybackConfigViewModel의 상태를 나타내며, 상태 변경에 따라 업데이트됩니다.
// NotifierProvider<NotifierT extends Notifier<T>, T>
final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigMedel>(
  () => throw UnimplementedError(),
);
