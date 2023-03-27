import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';

class NavTab extends StatelessWidget {
  const NavTab({
    super.key,
    required this.text,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    required this.selectedIcon,
  });

  final String text;
  final bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    //Expanded는 가능한한 확장시키는 것이다.
    return Expanded(
      child: GestureDetector(
        // 위젯이 파라미터로 넘겨받은 onTap함수를 제스쳐디텍터의 onTap에서 실행시킨다.
        // 외부에서 받아온 함수는 onTap: onTap, 처럼 쓸 수 없음
        // 따라서 아래와 같이 사용
        onTap: () => onTap(),
        child: Container(
          color: Colors.black,
          child: AnimatedOpacity(
            opacity: isSelected ? 1 : 0.6,
            duration: const Duration(milliseconds: 300),
            child: Column(
              //칼럼에게 children의 공간만큼만 차지하라고 명령
              //메인액시스(=세로축)의 사이즈를 최소화
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  isSelected ? selectedIcon : icon,
                  color: Colors.white,
                ),
                Gaps.v5,
                Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
