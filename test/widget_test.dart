import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

void main() {
  group(
    "Form Button Test",
    () {
      testWidgets(
        "Enable State",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            Theme(
              data: ThemeData(primaryColor: Colors.red),
              child: const Directionality(
                textDirection: TextDirection.ltr,
                child: FormButton(
                  disabled: false,
                ),
              ),
            ),
          );
          expect(find.text("Next"), findsOneWidget);
          expect(
            tester
                .firstWidget<AnimatedDefaultTextStyle>(
                    find.byType(AnimatedDefaultTextStyle))
                .style
                .color,
            Colors.white,
          );
          expect(
            (tester
                    .firstWidget<AnimatedContainer>(
                        find.byType(AnimatedContainer))
                    .decoration as BoxDecoration)
                .color,
            Colors.red,
          );
        },
      );
      testWidgets(
        "Disable State",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            // isDarkMode가 mediaquery를 사용하기 때문에
            // cotext를 가져오기 위해서 아래의 코드를 사용해야 한닥 하는데,
            // 없어도 작동함
            const MediaQuery(
              data: MediaQueryData(),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: FormButton(
                  disabled: true,
                ),
              ),
            ),
          );
          expect(
            tester
                .firstWidget<AnimatedDefaultTextStyle>(
                    find.byType(AnimatedDefaultTextStyle))
                .style
                .color,
            Colors.grey.shade400,
          );
        },
      );
      testWidgets(
        "Disabled State DarkMode",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MediaQuery(
              data: MediaQueryData(
                // 미디어쿼리데이터에서 강제로 설정해줌
                platformBrightness: Brightness.dark,
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: FormButton(disabled: true),
              ),
            ),
          );
          expect(
            (tester
                    .firstWidget<AnimatedContainer>(
                        find.byType(AnimatedContainer))
                    .decoration as BoxDecoration)
                .color,
            Colors.grey.shade800,
          );
        },
      );
      testWidgets(
        "Disabled State LightMode",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MediaQuery(
              data: MediaQueryData(
                // 미디어쿼리데이터에서 강제로 설정해줌
                platformBrightness: Brightness.light,
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: FormButton(disabled: true),
              ),
            ),
          );
          expect(
            (tester
                    .firstWidget<AnimatedContainer>(
                        find.byType(AnimatedContainer))
                    .decoration as BoxDecoration)
                .color,
            Colors.grey.shade300,
          );
        },
      );
    },
  );
}
