//이 파일은 데이터를 디스크에 persist하는 역할을 한다.
//persist: 데이터를 프로그램보다 오래 살리는 것
//Repository의 역할은 디스크에 데이터를 저장하고 읽는 것

import 'package:shared_preferences/shared_preferences.dart';

class VideoPlaybackConfigRepository {
  final SharedPreferences _preferences;

  VideoPlaybackConfigRepository(this._preferences);

  static const String _autoPlay = "autoPlay";
  static const String _muted = "muted";

  Future<void> setMuted(bool value) async {
    _preferences.setBool(_muted, value);
  }

  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_autoPlay, value);
  }

  bool isMuted() {
    //디스크에 데이터가 없으면 false로 간주하겠다는 뜻
    return _preferences.getBool(_muted) ?? false;
  }

  bool isAutoplay() {
    return _preferences.getBool(_autoPlay) ?? false;
  }
}
