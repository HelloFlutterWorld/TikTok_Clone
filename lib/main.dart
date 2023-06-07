import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';

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
  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //휴태폰에게 어떤 theme를 사용할지 알려주는 기능을 한다.
        //.system은 앱이 실행되는 기기의 환경에 맞추어 준다.
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        title: 'TikTok Clone',
        theme: ThemeData(
          //기본 글자색
          brightness: Brightness.light,
          textTheme: GoogleFonts.itimTextTheme(),
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
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0XFFE9435A),
        ),
        darkTheme: ThemeData(
          textTheme: GoogleFonts.itimTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme),
          scaffoldBackgroundColor: Colors.black,
          primaryColor: const Color(0XFFE9435A),
          //다크모드 글자색
          brightness: Brightness.dark,
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade800,
          ),
        ),
        home: const SignUpScreen());
  }
}
