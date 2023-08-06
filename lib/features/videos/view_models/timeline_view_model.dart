import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideoRepository _repository;
  List<VideoModel> _list = [];

/*   void uploadVideo() async {
    // loding state를 다시 설정한다.
    // timelineviewmodel이 다시 로딩되기를 원한다고 가정
    // 이렇게 함으로써 timelineviewmodel이 다시 loading state가 되도록 만들어줌
    // 현재 state는 로딩상태 => when(loading)
    state = const AsyncValue.loading();
    // 업로드가 지연되고 있다고 가정한다.
    // 로딩상태에서 필요한 작업들은 한다.
    await Future.delayed(const Duration(seconds: 2));

    // state를 직접 변경할 수 없으므로 _list.add(newVideo)는 사용못함
    // 왜냐면 화면을 다시 build 해주지 않음으로,
    // state가 새로 만들어 질 때, build메소드가 reBuild되어 사용자 화면이 업데이트된다.
    _list = [..._list];
    // state = _list 안됨 왜내면 AcyncNotifier안에 있기 때문
    // 현재 state는 data상태 when => when(data)
    state = AsyncValue.data(_list);
  } */

  @override
  // Future 또는 Model을 반환, Model만 반환하는 Notifier와 차이 있음
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videoRepo);
    // result는 일종의 도큐먼트들의 리스트라고 할 수 있다.
    // QuerySnapshot<Map<String, dynamic>>의 자료형을 갖는다.
    // 모든 도큐먼트들을 리스트값으로 갖느다.
    final result = await _repository.fetchVidoes();
    // map()는 새로운 리스트를 생성한다.
    // 도큐먼트들로 구성된 리스트(result)를 순환하며, 입력된 값을 반환한다.
    // 순환의 대상이 되는 값을 첫 번째 파라미터(doc)로 갖게 된다.
    // 어떤 값을 입력하든 newList에 추가된다.
    // Iterable<String>는 순환가능한 리스트로서 일종의 배열과 같은 것이다.
    final newList = result.docs.map(
      (doc) => VideoModel.fromJson(
        doc.data(),
      ),
    );
    print(newList);
    // build 메서드는 view가 받을 초기 데이터를 반환해준다.
    // 이 build 메소드에서 원하는 API를 호출하고,
    // 데이터를 반환하면, 그 데이터는 Provider에 의해 노출된다.
    // API롤 부터 응답받는 시간이 5초 정도 걸린다고 가정
    // await Future.delayed(const Duration(seconds: 5));

    // 22.4 AsyncNotifierProvider 11:56, next버튼 누룬 후 에러메시지 확인가능
    // throw Exception("OMG cant fetch");

    // newList를 _list에 담는 이유는 이미 가져온 비디오들의 복사본들 유지하기 위해서이다.
    // 왜냐면 나중에 페이지네이션을 할 때 리스트에 아이템들을 더 추가해야 하기 때문이다.
    _list = newList.toList();
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
