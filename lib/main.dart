import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/palyback_config_vm.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

import 'common/widgets/video_config/dark_config.dart';
//gen_l10n 임포트

void main() async {
  //플러터 프레임워크를 이용해서 앱이 시작하기 전에 state를 어떤 식으로든 바꾸고 싶다면
  // 엔진과 위젯의 연결을 확실하게 초기화 시켜야 한다.
  //This is the glue that binds the framework to the Flutter engine.
  //이 위젯은 엔진과 프레임워크를 바인딩해주는 접착체와 같다
  //이 함수는 런앱을 실행하기 전에 바인딩을 초기화 할 때만 호출해야 한다.
  WidgetsFlutterBinding.ensureInitialized();

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
  final repository = VideoPlaybackConfigRepository(preferences);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: ((context) => PlaybackConfigViewModel(repository))),
    ChangeNotifierProvider(create: (context) => DarkConfig()),
  ], child: const TikTokApp()));
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //언어설정을 영어로 강제
    //S.load(const Locale("en"));
    return MaterialApp.router(
      routerConfig: router,
      //휴태폰에게 어떤 theme를 사용할지 알려주는 기능을 한다.
      //.system은 앱이 실행되는 기기의 환경에 맞추어 준다.
      themeMode: context.watch<DarkConfig>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
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
    );
  }
}
