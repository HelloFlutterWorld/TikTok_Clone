import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [];

  void uploadVideo() async {
    // loding state를 다시 설정한다.
    // timelineviewmodel이 다시 로딩되기를 원한다고 가정
    // 이렇게 함으로써 timelineviewmodel이 다시 loading state가 되도록 만들어줌
    // 현재 state는 로딩상태 => when(loading)
    state = const AsyncValue.loading();
    // 업로드가 지연되고 있다고 가정한다.
    // 로딩상태에서 필요한 작업들은 한다.
    await Future.delayed(const Duration(seconds: 2));
    final newVideo = VideoModel(title: "${DateTime.now()}");
    // state를 직접 변경할 수 없으므로 _list.add(newVideo)는 사용못함
    // 왜냐면 화면을 다시 build 해주지 않음으로,
    // state가 새로 만들어 질 때, build메소드가 reBuild되어 사용자 화면이 업데이트된다.
    _list = [..._list, newVideo];
    // state = _list 안됨 왜내면 AcyncNotifier안에 있기 때문
    // 현재 state는 data상태 when => when(data)
    state = AsyncValue.data(_list);
  }

  @override
  // Future 또는 Model을 반환, Model만 반환하는 Notifier와 차이 있음
  FutureOr<List<VideoModel>> build() async {
    // build 메서드는 view가 받을 초기 데이터를 반환해준다.
    // 이 build 메소드에서 원하는 API를 호출하고,
    // 데이터를 반환하면, 그 데이터는 Provider에 의해 노출된다.
    // API롤 부터 응답받는 시간이 5초 정도 걸린다고 가정
    await Future.delayed(const Duration(seconds: 5));
    // 22.4 AsyncNotifierProvider 11:56, next버튼 누룬 후 에러메시지 확인가능
    // throw Exception("OMG cant fetch");
    return _list;
  }
}

// View들에게 (예를 들면 settingsScreen) View Model을 전달할 Provider를 만든다.
final timeLineProvider =
    // expose할 Notifier(View Model)이 무엇인지, 그 View Model의 데이터가 무엇인지 알려줌
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  // View Model을 초기화 해줄 function을 반환해 준다.
  () => TimelineViewModel(),
);
