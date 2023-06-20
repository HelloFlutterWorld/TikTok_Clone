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
        final username = state.params['username'];
        return UserProfileScreen(username: username!);
      },
    )
  ],
);
