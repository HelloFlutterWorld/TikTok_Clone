import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  Map<String, String> formData = {};
  void _onSubmitTap() {
    ref.read(usersProvider.notifier).updateProfile(
          name: formData["name"],
          bio: formData["bio"],
          link: formData["link"],
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Settings",
        ),
        actions: const [],
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: Breakpoints.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size36,
            ),
            child: Column(
              children: [
                Gaps.v28,
                TextFormField(
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "Name",
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
                  onChanged: (newValue) {
                    formData['name'] = newValue;
                  },
                ),
                Gaps.v16,
                TextFormField(
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "Biography",
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
                  onChanged: (newValue) {
                    formData['bio'] = newValue;
                  },
                ),
                Gaps.v16,
                TextFormField(
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "Homepage",
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
                  onChanged: (newValue) {
                    formData['link'] = newValue;
                  },
                ),
                Gaps.v28,
                GestureDetector(
                  onTap: _onSubmitTap,
                  child: const FormButton(
                    disabled: false,
                    text: "Submit",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
