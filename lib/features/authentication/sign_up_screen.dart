import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/features/authentication/widgets/usernamel_screen.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/";
  const SignUpScreen({super.key});

  void _onLoginTap(BuildContext context) async {
    context.push(LoginScreen.routeName);
  }

  void _onEmailTap(BuildContext context) {
    /* Navigator.of(context).push(
      PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const UsernameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offsetAnimation = Tween(
              //x가로축, y세로축 -1은 -100%
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation);
            final opacityAnimation = Tween(
              begin: 0.5,
              end: 1.0,
            ).animate(animation);
            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: opacityAnimation,
                child: child,
              ),
            );
          }),
    ); */
    //Navigator.pushNamed(context, UsernameScreen.routeName);
    //go는 push, pop와 달리 페이지 스택을 무시하고 원하는 곳으로 route해준다.
    context.push(UsernameScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    //현재 어떤 언어로 되어있는지 확인하는 코드
    //print(Localizations.localeOf(context));
    return OrientationBuilder(
      builder: (context, orientation) {
        //builer은 위젯을 반환받는 Function이다.
        //콘텍스트와 오리엔테이션을 넘겨받는다.
        //required this.builder,
        //final OrientationWidgetBuilder builder;
        //typedef OrientationWidgetBuilder = Widget Function(BuildContext context, Orientation orientation);
        //enum Orientation {portrait,landscape}

        //Orientation
        /*  if (orientation == Orientation.landscape) {
          return const Scaffold(
            body: Center(
              child: Text("Please rotate your phone"),
            ),
          );
        } */
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size40,
              ),
              child: Column(
                children: [
                  Gaps.v80,
                  Text(
                    S.of(context).signUpTitle("TikTok"),
                    //copytWith()스타일을 그대로 사용하면서 다른 요소들을 추가할 수 있다.
                    style: const TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v20,
                  Opacity(
                    opacity: 0.7,
                    child: Text(
                      //codeAction -> Extract to ARB
                      S.of(context).signUpSubtitle(100),
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gaps.v40,
                  // ... 스프레드 연산자
                  // 세미콜론을 찍을 수 없는 위젯문 안에서 리스트를 반환해준다.
                  if (orientation == Orientation.portrait) ...[
                    GestureDetector(
                      onTap: () => _onEmailTap(context),
                      child: AuthButton(
                        icon: const FaIcon(FontAwesomeIcons.user),
                        text: S.of(context).emailPassworButton,
                      ),
                    ),
                    Gaps.v16,
                    AuthButton(
                      text: S.of(context).appleButton,
                      icon: const FaIcon(FontAwesomeIcons.apple),
                    ),
                  ],
                  if (orientation == Orientation.landscape)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onEmailTap(context),
                            child: AuthButton(
                              icon: const FaIcon(FontAwesomeIcons.user),
                              text: S.of(context).emailPassworButton,
                            ),
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          //AuthButton은 사이즈드박스로 둘려쌓여있는데
                          //이는 무한대의 크기를 가진다.
                          child: AuthButton(
                            text: S.of(context).appleButton,
                            icon: const FaIcon(FontAwesomeIcons.apple),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: isDarkMode(context) ? null : Colors.grey.shade50,
            //elevation: 2,
            child: Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size32,
                bottom: Sizes.size64,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).alreadyHaveAnAccount,
                  ),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onLoginTap(context),
                    child: Text(
                      S.of(context).logIn("male"),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
