import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class PostVideoButton extends StatelessWidget {
  final bool isInverted;
  const PostVideoButton({
    super.key,
    required this.isInverted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Stack(
      //stack가 오버플로우되는 element를 숨기지 못하도록
      //이런것을 clipping라고 하는데 이걸 하지 못하도록 아래와 같이
      clipBehavior: Clip.none,
      children: [
        //stack 내부의 elements를 이동시킬  수 있게 해줌
        Positioned(
          right: 20,
          child: Container(
            height: 30,
            width: 25,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff61D4F0),
              borderRadius: BorderRadius.circular(
                Sizes.size8,
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          child: Container(
            height: 30,
            width: 25,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(
                Sizes.size8,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size12,
          ),
          height: 30,
          decoration: BoxDecoration(
            color: !isInverted || isDark ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(
              Sizes.size6,
            ),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: !isInverted || isDark ? Colors.black : Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
