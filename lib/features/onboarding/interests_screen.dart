import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/onboarding/widgets/interest_button.dart';
import 'package:tiktok_clone/features/onboarding/widgets/tutorial_screen.dart';

const interests = [
  "Daily Life",
  "Comedy",
  "Entertainment",
  "Animals",
  "Food",
  "Beauty & Style",
  "Drama",
  "Learning",
  "Talent",
  "Sports",
  "Auto",
  "Family",
  "Fitness & Health",
  "DIY & Life Hacks",
  "Arts & Crafts",
  "Dance",
  "Outdoors",
  "Oddly Satisfying",
  "Home & Garden",
  "Daily Life",
  "Comedy",
  "Entertainment",
  "Animals",
  "Food",
  "Beauty & Style",
  "Drama",
  "Learning",
  "Talent",
  "Sports",
  "Auto",
  "Family",
  "Fitness & Health",
  "DIY & Life Hacks",
  "Arts & Crafts",
  "Dance",
  "Outdoors",
  "Oddly Satisfying",
  "Home & Garden",
];

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _showTitle = false;

  void _onScroll() {
    if (_scrollController.offset > 100) {
      //offset의 값이 101,102,103이 되더라도 true로 변경하지 않는다.
      if (_showTitle) return;
      setState(() {
        _showTitle = true;
      });
    } else {
      setState(() {
        _showTitle = false;
      });
    }
  }

  void _onNextTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TutorialScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    //offset는 위에서부터 얼마나 스크롤되었는지 알려준다.
    //print(_scrollController.offset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //움직임에 따라 투명도를 조절하는 위젯이다.
          title: AnimatedOpacity(
            opacity: _showTitle ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: const Text("Choose your interests"),
          ),
        ),
        body: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: Sizes.size16,
                left: Sizes.size24,
                right: Sizes.size24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v32,
                  const Text(
                    "Choose your interests",
                    style: TextStyle(
                      fontSize: Sizes.size40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v20,
                  const Text(
                    "Get better video recommendations",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v64,
                  //Wrap는 children을 옆으로 배치하되 한줄아 안들어가면
                  //줄바꿈을 한다.
                  Wrap(
                    runSpacing: 15,
                    spacing: 15,
                    children: [
                      for (var interest in interests)
                        InterestButton(interest: interest),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: Sizes.size40,
              top: Sizes.size16,
              left: Sizes.size24,
              right: Sizes.size24,
            ),
            child: GestureDetector(
              onTap: _onNextTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size20,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  "Next",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size16,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
