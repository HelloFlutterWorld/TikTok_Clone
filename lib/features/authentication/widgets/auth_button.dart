import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final FaIcon icon;
  final void Function(BuildContext context)? onTap;

  const AuthButton({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
    //required this.onGesture,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      {
        return GestureDetector(
          onTap: () => onTap!(context),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.grey.shade300,
                width: Sizes.size1,
              )),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: icon,
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.grey.shade300,
          width: Sizes.size1,
        )),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: icon,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
