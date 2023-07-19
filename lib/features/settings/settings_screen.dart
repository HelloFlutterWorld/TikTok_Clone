import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/widgets/video_config/dark_config.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/features/videos/view_models/palyback_config_vm.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  /* 
   bool _notifications = false;

  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }
 */

  @override
  // ConsumerWidget을 상속받으면 추가매개변수로 WidgetRef ref를 받아온다.
  // 이것은 Provider를 가져오거나, 읽을 수 있는 레퍼런스(참조변수)다.
  Widget build(BuildContext context, WidgetRef ref) {
    // 해당페이지에서 언어를 따로 설정하는 것 가능
    // return Localizations.override(
    //   context: context,
    //   locale: const Locale("en"),
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Align(
        child: Container(
          constraints: const BoxConstraints(maxWidth: Breakpoints.md),
          child: ListView(
            children: [
              /* AnimatedBuilder(
                animation: videoConfig,
                builder: (context, child) => SwitchListTile.adaptive(
                  value: videoConfig.value,
                  onChanged: (value) {
                    //videoConfig.toggleAutoMute();
                    videoConfig.value = !videoConfig.value;
                  },
                  title: const Text("Mute Video"),
                  subtitle: const Text("Videos will be muted by default."),
                ),
              ), */
              /* ValueListenableBuilder(
                //videoConfig구독, 값이 변할 때마다 리빌드해준다.
                valueListenable: videoConfig,
                builder: (context, value, child) => SwitchListTile.adaptive(
                  value: value,
                  onChanged: (value) {
                    //videoConfig.toggleAutoMute();
                    videoConfig.value = !videoConfig.value;
                  },
                  title: const Text("Mute Video"),
                  subtitle: const Text("Videos will be muted by default."),
                ),
              ), */
              ValueListenableBuilder(
                valueListenable: systemDarkMode,
                builder: (context, value, child) => SwitchListTile.adaptive(
                  value: value,
                  onChanged: (value) =>
                      {systemDarkMode.value = !systemDarkMode.value},
                  title: const Text("Dark Mode"),
                  subtitle: const Text("Dark mode will be applied by default."),
                ),
              ),
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).muted,
                onChanged: (value) =>
                    // .notifier "나는 데이터는 필요없고, 클래스에 접근하고 싶다"는 뜻
                    ref.read(playbackConfigProvider.notifier).setMuted(value),
                title: const Text("Mute Video"),
                subtitle: const Text("Video will be muted by default."),
              ),
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).autoplay,
                onChanged: (value) => ref
                    .read(playbackConfigProvider.notifier)
                    .setAutoplay(value),
                title: const Text("Autoplay"),
                subtitle: const Text("Video will start playing automatically."),
              ),
              SwitchListTile.adaptive(
                value: false,
                onChanged: (value) {},
                title: const Text("Enable notifications"),
                subtitle: const Text("Enable notifications"),
              ),
              CheckboxListTile(
                activeColor: Colors.black,
                value: false,
                onChanged: (value) {},
                title: const Text("Enable notifications"),
              ),
              ListTile(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1980),
                    lastDate: DateTime(2030),
                  );
                  if (kDebugMode) {
                    print(date);
                  }
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (kDebugMode) {
                    print(time);
                  }
                  //await안에서 context를 사용하는 것은 좋지 않다.
                  //mount되지 않았다면, showDateRangePicker를 호출하지 않는다.
                  final booking = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(1980),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData(
                            appBarTheme: const AppBarTheme(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black)),
                        child: child!,
                      );
                    },
                  );
                  if (kDebugMode) {
                    print(booking);
                  }
                },
                title: const Text("What is your birthday?"),
              ),
              ListTile(
                title: const Text("Log out (iOS)"),
                textColor: Colors.red,
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text("Plx dont go"),
                      actions: [
                        CupertinoDialogAction(
                          //현재 새로운 Route를 push한 상태이므로 pop해준다.
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("No"),
                        ),
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(),
                          //No Yes 색깔 바뀜 뭔지 모르겠음
                          isDestructiveAction: true,
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Log out (iOS / Bottom)"),
                textColor: Colors.red,
                onTap: () {
                  //modal밖을 누르면 pop됨
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: const Text("Are you sure?"),
                      message: const Text("Pleese dooont goooo"),
                      actions: [
                        CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Not log out"),
                        ),
                        CupertinoActionSheetAction(
                          //색깔 구분됨
                          isDestructiveAction: true,
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Yes Plz."),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const AboutListTile(
                applicationVersion: "1.0",
                applicationLegalese: "Don't copy me",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
