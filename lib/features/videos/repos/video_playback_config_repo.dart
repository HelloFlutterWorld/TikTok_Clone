//이 파일은 데이터를 디스크에 persist하는 역할을 한다.
//persist: 데이터를 프로그램보다 오래 살리는 것
//Repository의 역할은 디스크에 데이터를 저장하고 읽는 것

import 'package:shared_preferences/shared_preferences.dart';

class VideoPlaybackConfigRepository {
  static const String _autoPlay = "autoPlay";
  static const String _muted = "muted";

  final SharedPreferences _preferences;

  VideoPlaybackConfigRepository(this._preferences);

  Future<void> setMuted(bool value) async {
    _preferences.setBool(_muted, value);
  }

  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_autoPlay, value);
  }
}
