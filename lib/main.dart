import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/common/widgets/video_config/dark_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/palyback_config_vm.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

import 'firebase_options.dart';

//gen_l10n 임포트

void initializeFirebaseApp() async {
  try {
    // 이미 Firebase 앱이 초기화되었는지 확인
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        // 현재 플랫폼에 대한 기본 Firebase 옵션을 사용한다는 의미
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print("Firebase 초기화 오류: $e");
    }
  }
}

void main() async {
  //플러터 프레임워크를 이용해서 앱이 시작하기 전에 state를 어떤 식으로든 바꾸고 싶다면
  //엔진과 위젯의 연결을 확실하게 초기화 시켜야 한다.
  //This is the glue that binds the framework to the Flutter engine.
  //이 위젯은 엔진과 프레임워크를 바인딩해주는 접착체와 같다
  //이 함수는 런앱을 실행하기 전에 바인딩을 초기화 할 때만 호출해야 한다.
  WidgetsFlutterBinding.ensureInitialized();

  initializeFirebaseApp();

  // Firebase 애플리케이션 인스턴스를 초기화하고 반환하는 비동기 함수다.
  // 초기화하는 시점에 아래와 같이 FirebaseAuth instance를 만들면
  // final authRepo = Provider((ref) => AuthenticationRepository());
  // 바로 Firebase와 소통할 수 있다.
  // await Firebase.initializeApp(
  //   //  현재 플랫폼에 대한 기본 Firebase 옵션을 사용한다는 의미
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  //Future<void>이기 때문에 비동기키워드 await 써줌
  await SystemChrome.setPreferredOrientations(
    [
      //potrait모드로만 작동한다.
      DeviceOrientation.portraitUp,
    ],
  );
  //시스템오버레이스타일 와이파이, 배터리 표시등의 색깔
  //이 함수는 메인함수뿐만 아니라 원하는 곳 어디서든 사용 가능
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );

  //getInstance 비동기적 인스턴스(객체)를 생성한다.
  final preferences = await SharedPreferences.getInstance();
  //preferences를 참조전달하여 저장소객체를 생성한다.
  final repository = VideoPlaybackConfigRepository(preferences);

  runApp(ProviderScope(
    overrides: [
      playbackConfigProvider
          //Override overrideWith(PlaybackConfigViewModel Function() create)
          .overrideWith(() => PlaybackConfigViewModel(repository)),
    ],
    child: const TikTokApp(),
  ));
}

class TikTokApp extends ConsumerWidget {
  const TikTokApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //언어설정을 영어로 강제
    //S.load(const Locale("en"));
    return ValueListenableBuilder(
      valueListenable: systemDarkMode,
      builder: (context, value, child) => MaterialApp.router(
        // GoRouter를 담은 Provider를 watch 한다.
        routerConfig: ref.watch(routerProvider),
        //휴태폰에게 어떤 theme를 사용할지 알려주는 기능을 한다.
        //.system은 앱이 실행되는 기기의 환경에 맞추어 준다.
        themeMode: systemDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        title: 'TikTok Clone',
        localizationsDelegates: const [
          //command pallete -> Flutter intl: initialize
          //command pallete -> Flutter intl: add locale "ko"
          S.delegate,
          //플러터에는 텍스트가 기본적으로 들어가있는 위젯들이 있다.
          //예를 들면 licenses 같은 것들
          //플러터가 기본적으로 가지고 있는 위젯들에 대한 번역들을 include 시켜준다.
          //calendar, clock 등
          //아래의 코드들은 일종의 번역 파일들이다.
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          //www.iana.org => Locale에 사용가능한 코드확인
          Locale("en"),
          Locale("ko"),
        ],
        theme: ThemeData(
            useMaterial3: true,
            //Robotov폰트를 기반으로 한다.
            //font와 color만 제공하는 textTheme완성
            textTheme: Typography.blackMountainView,
            //기본 글자색
            brightness: Brightness.light,
            //앱 전체의 스플래쉬 효과 제거하기
            splashColor: Colors.transparent,
            //앱 전체의 롱프레스 스플래쉬 효과 제저하기
            //highlightColor: Colors.transparent,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0XFFE9435A),
            ),
            appBarTheme: const AppBarTheme(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              //앱바가 사라질 때 나타나는 색깔
              surfaceTintColor: Colors.white,
              elevation: 0,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: Sizes.size16 + Sizes.size2,
                fontWeight: FontWeight.w600,
              ),
            ),
            tabBarTheme: TabBarTheme(
              //밑줄색
              indicatorColor: Colors.black,
              //선택된 탭의 글자색
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.shade500,
            ),
            scaffoldBackgroundColor: Colors.white,
            primaryColor: const Color(0XFFE9435A),
            listTileTheme: const ListTileThemeData(
              iconColor: Colors.black,
            )),
        darkTheme: ThemeData(
          useMaterial3: true,
          tabBarTheme: TabBarTheme(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade700,
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0XFFE9435A),
          ),
          //Roboto를 기반으로 한다.
          //font와 color만 제공하는 textTheme완성
          textTheme: Typography.whiteMountainView,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: const Color(0XFFE9435A),
          //다크모드 글자색
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
            surfaceTintColor: Colors.grey.shade900,
            backgroundColor: Colors.grey.shade900,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
            iconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade900,
          ),
        ),
      ),
    );
  }
}
