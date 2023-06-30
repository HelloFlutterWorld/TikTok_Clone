import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/email_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';
import 'package:tiktok_clone/utils.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  //controller는 코드, 메소드 등으로 textfield와 같은 위젯을 컨트롤 할 수 있도록 해줌
  //생성된 컨트롤러를 텍스트필드에 넘겨준다.
  final TextEditingController _usernameController = TextEditingController();

  String _username = "";

  @override
  void initState() {
    super.initState();
    //사용자의 입력텍스트를 스테이트에 저장
    _usernameController.addListener(() {
      setState(() {
        _username = _usernameController.text;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    //슈퍼는 디스포즈뒤에 놓는다. 마치 소멸자와 같은?
    super.dispose();
  }

  //state 안에 있다면, 어디서든 context를 사용할 수 있으므로, context를 전달받을 필요없다.
  void _onNextTap() {
    if (_username.isEmpty) return;
    /*context.pushNamed(EmailScreen.routeName,
        //push는 page stack에 location을 push한다.
        //이것은 이전 화면 위에 다른 화면을 올린다는 뜻이다.

        //extra를 사용하여 페이지 스택 위에 푸시되는 경로(path:"/email")로
        //데이터를 전달할 수 있다.
        //EmailScreenArgs 객체는 페이지 스택 위에 쌓이는 경로(path:"/email")로
        //함께 저장되며,
        //이후 해당 경로(path:"/email")호출하는 GoRoute에서
        //builder 함수를 콜백하여 state.extra를 통해 해당 객체에 접근할 수 있다.

        //extra: EmailScreenArgs(username: _username),
        //위 구문 자체가 객체를 생성하고 router에서 state.extra로 접근 가능한 형태다.
        //이를 통해 생성된 EmailScreenArgs 객체의 속성이나 메서드에 접근하여 사용할 수 있다.
        extra: EmailScreenArgs(username: _username)); */
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailScreen(username: _username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign up",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40,
            const Text(
              "Create username",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v8,
            Text(
              "You can always change this later.",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: isDarkMode(context) ? Colors.white : Colors.black54,
              ),
            ),
            Gaps.v16,
            TextField(
              onEditingComplete: _onNextTap,
              //사용자의 입력텍스트를 스테이트에 저장
              //텍스트필드는 컨트롤러 프로퍼티를 가지고 있다.
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Username",
                //처음 볼 때 밑 줄
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                //탭 했을 때 밑 줄
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Gaps.v28,
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(
                disabled: _username.isEmpty,
              ),
            )
          ],
        ),
      ),
    );
  }
}
