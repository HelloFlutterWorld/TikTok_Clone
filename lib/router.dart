import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

import 'features/inbox/views/activity_screen.dart';
import 'features/inbox/views/chat_detail_screen.dart';
import 'features/inbox/views/chats_screen.dart';
import 'features/notifications/notificatons_provider.dart';

// ref object에 접근할 수 있으며,
// 이것은 다른 provider를 읽을 수 있게 해준다.
// 가장 기본적인 Provider, 값이 무엇이든, 값을 노출해준다.
// GoRouter를 Provider안에 넣었다.
final routerProvider = Provider((ref) {
  // 이렇게만 해 주면 authState에 변화가 있을 때
  // 이 dependency(authState)에 변화가 있으니 provider가 rebuild 될 거고
  // 그럼 자동으로 redirect 된다.
  // authState가 변경되면 routerProvider가 리빌드되는 이유는
  // routerProvider가 authState에 의존하고 있기 때문이다.
  // 이러한 의존성으로 인해 authState가 변경될 때마다 routerProvider는
  // 해당 변화를 감지하고 자동으로 리빌드되어 새로운 값을 사용한다
  // ref.watch(authState); 이렇게 할 수도 있음
  return GoRouter(
    // 앱을 리프레시 하면 먼저 "/home"화면으로 간다
    initialLocation: "/home",
    redirect: (context, state) {
      // state의 값에 따라 user를 어디로 redirect시킬 지 정할 수 있다.
      final isLoggedIn = ref.read(authRepo).isLoggedIn;

      // 먼저 유저가 로그인되었는지 확인하고
      if (!isLoggedIn) {
        // router의 sub location이라는 뜻이다.
        // 로그인 되지 않은 상태에서
        // signup 화면이 아닌 다른곳으로 가려고 하거나, login 화면이 아닌곳으로 가려고 할 때,
        // signup("/")화면으로 보내준다.
        // 처음부터 "/home"으로 가려고 했으니, 로그인이 되어 있지 않다면
        // 아래의 조건문은 자동으로 참이 된다. 왜냐면 처음부터 "/home"으로 가려고 했으니까.
        // 그리고 state.subloc는 사용자가 현재 접속한 위치 또는 이동하고자 하는 위치를 나타내는 것이다.
        if (state.subloc != SignUpScreen.routeURL &&
            state.subloc != LoginScreen.routeURL) {
          return SignUpScreen.routeURL;
        }
      }
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          // notificationsProvider에서 사용되는  context.go가
          // main함수의 routerConfig 보다 먼저 나오고 있음으로 shellRoute로
          // 감싸줘야 한다. 이것으로 모든 route를 감싸서 notifierProvider를
          // 초기화 해줄 수 있다.
          // 강의 29.4 ShellRoute 2:40
          // context를 넘겨 받는 notificationsProvider가 실행되어
          // 앱이 받게될 알림들을 감사한다.
          ref.read(notificationsProvider(context));
          // child에는 아래의 Goroute들이 각각 소유하고 있는 내용들이 담겨있다.
          // 예를 들어 SignupScreen으로 라우팅되면
          // child에는
          // GoRoute(
          // name: SignUpScreen.routeName,
          // path: SignUpScreen.routeURL,
          // builder: (context, state) => const SignUpScreen(),)가 담기게 된다.
          return child;
        },
        routes: [
          GoRoute(
            name: SignUpScreen.routeName,
            path: SignUpScreen.routeURL,
            builder: (context, state) => const SignUpScreen(),
            /* name: SignUpScreen.routeName,
      routes: [
        GoRoute(
          path: UsernameScreen.routeURL,
          name: UsernameScreen.routeNAme,
          builder: (context, state) => const UsernameScreen(),
          routes: [
            GoRoute(
              path: EmailScreen.routeURL,
              name: EmailScreen.routeName,
              //현재경로는 "/username" 즉 username_screen.dart다
              //builder 콜백 함수의 state 매개변수는 현재 경로의 상태 정보를 나타내며,
              //해당 경로로 이동할 때마다 업데이트된다. 이를 활용하여 경로에 따라 다른 화면을
              //렌더링하거나 상태를 관리할 수 있다.
              builder: (context, state) {
                //extra는 GoRouterState 객체에 추가적인 데이터를 전달하기 위한 매개변수로 사용되며,
                //경로와 관련된 부가적인 정보를 저장하고 활용할 수 있다.
                //state.extra는 일반적으로 dynamic 타입으로 추론될 것아다.
                //dynamic은 동적 타입으로, 컴파일러가 해당 객체의 실제 타입을 알지 못한다
                //그러나 state.extra 객체가 EmailScreenArgs 타입으로 선언되었다는 것을 알고 있다.
                //따라서 as EmailScreenArgs로 타입 캐스팅이 필요하다.
                //컴파일러에게 알려주어야 한다.
                //그러면 args.username을 사용하여 해당 객체의 속성에 접근할 수 있다.
                final args = state.extra as EmailScreenArgs;
                return EmailScreen(username: args.username);
              },
            ),
          ],
        ),
      ],
    ),
    /*  GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ), */
    /*  GoRoute(
      name: "username_screen",
      path: UsernameScreen.routeName,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          //child: 가고 싶은 곳
          child: const UsernameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //7.5 AnimationController, 10.4 RotationTransition, 11.2 AnimatedList 참조
            //class AnimationController extends Animation<double>
            //abstract class Animation<T> extends Listenable implements ValueListenable<T>
            /* SlideTransiosion 
              final offsetAnimation = Tween(
              //두 state 사이의 beTween
              //x가로축, y세로축 -1은 -100%
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation); */
            final opacityAnimation = Tween(
              //투명도 시작과 끝
              //기본 opacity는 0부터 1
              begin: 0.5,
              end: 1.0,
            ).animate(animation);
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: opacityAnimation,
                child: child,
              ),
            );
          },
        );
      },
    ), */

    GoRoute(
      //웹 주소창에서 이름을 직접 입력해도 반응하도록
      path: "/users/:username",
      builder: (context, state) {
        /* print(state.params); 
        {username: nico}*/
        //사용자가 입력한 username을 받아서 문자열로 생성
        //따라서 Map인 state.params에서 ['username']를 추출함
        //그럼 사용자가 입력한 이름이 추출됨
        final username = state.params['username'];
        //query parameters(쿼리 매개변수)는 URI(Uniform Resource Identifier)에서
        //사용되는 매개변수다. URI는 인터넷에서 리소스(웹 페이지, 이미지, 동영상 등)를 나타내는
        //고유한 식별자로 사용된다.
        final tab = state.queryParams["show"];
        //UserProfileScreen에 파라미터로 전달
        return UserProfileScreen(username: username!, tab: tab!);
      }, */
          ),
          GoRoute(
            name: LoginScreen.routeName,
            path: LoginScreen.routeURL,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            name: InterestsScreen.routeName,
            path: InterestsScreen.routeURL,
            builder: (context, state) => const InterestsScreen(),
          ),
          GoRoute(
            path: "/:tab(home|discover|inbox|profile)",
            name: MainNavigationScreen.routeName,
            builder: (context, state) {
              final tab = state.params['tab']!;
              return MainNavigationScreen(
                //tab: statelparams['tab']!,도 가능
                tab: tab,
              );
            },
          ),
          GoRoute(
            path: ActivityScreen.routeURL,
            name: ActivityScreen.routeName,
            builder: (context, state) => const ActivityScreen(),
          ),
          GoRoute(
            path: ChatsScreen.routeURL,
            name: ChatsScreen.routeName,
            builder: (context, state) => const ChatsScreen(),
            routes: [
              GoRoute(
                name: ChatDetailScreen.routeName,
                path: ChatDetailScreen.routeURL,
                builder: (context, state) {
                  //"final chatId"는 GoRoute의 객체가 갖고 있는 인스턴스다.
                  //context.pushNamed(ChatDetailScreen.routeName, params: {"chatId": "$index"});
                  final chatRoomId = state.params['chatRoomId']!;
                  // ignore: unused_local_variable
                  final args = state.extra as ChatDetailScreenArg;
                  return ChatDetailScreen(
                    chatRoomId: chatRoomId,
                    profile: args.profile,
                    chatRoom: args.chatRoom,
                    isFromChatList: args.isFromChatList,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: VideoRecordingScreen.routeName,
            path: VideoRecordingScreen.routeURL,
            pageBuilder: (context, state) => CustomTransitionPage(
              transitionDuration: const Duration(
                milliseconds: 200,
              ),
              child: const VideoRecordingScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final position =
                    Tween(begin: const Offset(0, 1), end: Offset.zero)
                        .animate(animation);
                return SlideTransition(
                  position: position,
                  child: child,
                );
              },
            ),
          ),
        ],
      )
    ],
  );
});
