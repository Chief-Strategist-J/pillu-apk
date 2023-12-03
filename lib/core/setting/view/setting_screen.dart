import 'package:example/core/chat/view/profile_screen.dart';
import 'package:example/core/util/dialog.dart';
import 'package:example/core/util/extension.dart';
import 'package:example/core/util/image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Settings', elevation: 0),
      body: SettingSection(
        title: Text('General', style: primaryTextStyle()),
        items: [
          SettingItemWidget(
            title: 'Profile',
            onTap: () {
              ProfileScreen().launch(context);
            },
            trailing: ic_right.showImage(context, width: 18, height: 18),
          ),
          SettingItemWidget(
            title: 'Change Password',
            trailing: ic_right.showImage(context, width: 18, height: 18),
            onTap: () {
              showCustomDialog(context);
            },
          ),
          SettingItemWidget(
            title: 'My Notification',
            trailing: ic_right.showImage(context, width: 18, height: 18),
            onTap: () {
              toast('Under Construction');
            },
          ),
          SettingItemWidget(
            title: 'Language',
            trailing: ic_right.showImage(context, width: 18, height: 18),
            onTap: () {
              toast("Not available yet");
            },
          ),
          SettingItemWidget(
            title: 'Create Account(Under-Construction)',
            trailing: ic_right.showImage(context, width: 18, height: 18),
            onTap: () {
              toast("Not available yet");
            },
          ),
        ],
      ),
    );
  }
}
