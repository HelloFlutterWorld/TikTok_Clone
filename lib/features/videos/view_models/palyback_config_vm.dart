import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_midel.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  final VideoPlaybackConfigRepository _repository;

  late final PlaybackConfigMedel _model = PlaybackConfigMedel(
    muted: _repository.isMuted(),
    autoplay: _repository.isAutoplay(),
  );

  PlaybackConfigViewModel(this._repository);

  bool get muted => _model.muted;
  bool get autoplay => _model.autoplay;

  void setMuted(bool value) {
    //1. 데이터를 persist한다.
    _repository.setMuted(value);
    //2. 데이터를 수정한다.
    _model.muted = value;
    //구독자에게 통보한다.
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    _model.autoplay = value;
    notifyListeners();
  }
}
