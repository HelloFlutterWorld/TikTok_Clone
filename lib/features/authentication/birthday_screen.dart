import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends ConsumerState<BirthdayScreen> {
  //controller는 코드, 메소드 등으로 textfield와 같은 위젯을 컨트롤 할 수 있도록 해줌
  //생성된 컨트롤러를 텍스트필드에 넘겨준다.
  final TextEditingController _birthdayController = TextEditingController();

  DateTime initialDate = DateTime(
    DateTime.now().year - 12,
    //int.parse(DateTime.now().toString().split(" ").first.split("-").first) - 12,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    super.initState();
    _setTextFieldDate(initialDate);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    //슈퍼는 디스포즈뒤에 놓는다. 마치 소멸자와 같은?
    super.dispose();
  }

  //state 안에 있다면, 어디서든 context를 사용할 수 있으므로, context를 전달받을 필요없다.
  void _onNextTap() {
/*     Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const InterestsScreen(),
      ),
      // bool Function(Route<dynamic>) predicate
      // predicate가 true를 리턴하면 이전화면을 돌아갈 수 있다.
      // false면 못돌아간다.
      (route) => false,
    ); */
    // context.goNamed(InterestsScreen.routeName);
    ref.read(signUpProvider.notifier).signUp();
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ").first;
    //컨트롤러의 vlaue를 textfield에 반영하고,
    //컨트롤러로 textfield의 값을 설정하려면 아래와 같이 입력
    _birthdayController.value = TextEditingValue(text: textDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
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
              "When's your birthday?",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v8,
            const Text(
              "Your birthday won't be shown publicly.",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black54,
              ),
            ),
            Gaps.v16,
            TextField(
              //textfield 비활성화
              enabled: false,
              //사용자의 입력텍스트를 스테이트에 저장
              //텍스트필드는 컨트롤러 프로퍼티를 가지고 있다.
              //컨트롤러로 textfield의 값을 설정하려면 아래와 같이 입력
              controller: _birthdayController,
              decoration: InputDecoration(
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
              child: FormButton(disabled: ref.watch(signUpProvider).isLoading),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 300,
        child: CupertinoDatePicker(
          maximumDate: initialDate,
          initialDateTime: initialDate,
          //날짜만 표시하기
          mode: CupertinoDatePickerMode.date,
          //유저가 날짜나 시간을 바꿀 때마다 호출됨
          onDateTimeChanged: _setTextFieldDate,
        ),
      ),
    );
  }
}
