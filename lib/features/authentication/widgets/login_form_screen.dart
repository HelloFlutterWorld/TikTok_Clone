import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

//TextFormField 는 컨트롤러, 리스터, setState가 필요없다.

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  //global key는 고유 식별자같은 역할을 하고
  //이 것을 사용하면 form의 state에도 접근할 수 있으며
  //form의 메서드도 실행시킬 수 있다.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      //[Form]의 하위 항목인 모든 [textFormField]의 유효성을 검사하고 오류가 없으면 true를 반환
      //유효성 검사를 잘 통과하면 textformfield의 onsaved 함수를 콜백한다.
      if (_formKey.currentState!.validate()) {
        //Form을 세이브하면 모든 텍스트 입력에 대해 onSaved 콜백함수를 실행하게 된다.
      }
      _formKey.currentState!.save();
      //push는 다른화면의 위에 올려놓는 것을 말한다.
      /* Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const InterestsScreen(),
        ),
        // bool Function(Route<dynamic>) predicate
        // predicate가 true를 리턴하면 이전화면을 돌아갈 수 있다.
        // false면 못돌아간다.
        (route) => false,
      ); */
    }
    context.goNamed(InterestsScreen.routeName);
    //_formKey.currentState?.validate()
    //1. 단순한 유효성 검사를 한 후
    //2. 이상 없으면 true 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gaps.v28,
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                //value는 스트링이며, 텍스트폼필드의 값이다.
                //String?을 받아서 String?을 반환하는 함수
                //onSubmitTap에서 유효성 검사가 실행되고 통과되면
                //여기로 와서 validator 함수가 콜백된다.
                validator: (value) {
                  //에러메시지를 반환하지 않는 상황에서는 newValue에 save한다.
                  if (value != null && value.isEmpty) {
                    return "Plase write your email";
                  }
                  return null;
                },
                //저장된 순간의 입력값이다.
                //onSubmitTap에서 유효성 검사를 잘 통과하면
                //여기로 와서 onSaved 함수가 콜백된다.
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['email'] = newValue;
                  }
                },
              ),
              Gaps.v16,
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Plase write your password";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['password'] = newValue;
                  }
                },
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSubmitTap,
                child: const FormButton(
                  disabled: false,
                  text: "Log in",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
