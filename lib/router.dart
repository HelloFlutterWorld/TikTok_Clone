import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/%20users/user_profile_screen.dart';

import 'features/authentication/login_screen.dart';
import 'features/authentication/sign_up_screen.dart';
import 'features/authentication/widgets/email_screen.dart';
import 'features/authentication/widgets/usernamel_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: UsernameScreen.routeName,
      builder: (context, state) => const UsernameScreen(),
    ),
    GoRoute(
      path: EmailScreen.routeName,
      builder: (context, state) => const EmailScreen(),
    ),
    GoRoute(
      //웹 주소창에서 이름을 직접 입력해도 반응하도록
      path: "/users/:username",
      builder: (context, state) {
        //사용자가 입력한 username을 받아서 문자열로 생성
        final username = state.params['username'];
        //query parameters(쿼리 매개변수)는 URI(Uniform Resource Identifier)에서
        //사용되는 매개변수다. URI는 인터넷에서 리소스(웹 페이지, 이미지, 동영상 등)를 나타내는
        //고유한 식별자로 사용된다.
        final tab = state.queryParams["show"];
        //UserProfileScreen에 파라미터로 전달
        return UserProfileScreen(username: username!, tab: tab!);
      },
    )
  ],
);
