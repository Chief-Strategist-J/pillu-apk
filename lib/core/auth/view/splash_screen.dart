import 'package:example/core/chat/chat_api.dart';
import 'package:example/core/chat/model/register_user_model.dart';
import 'package:example/core/auth/view/login_screen.dart';
import 'package:example/core/chat/view/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  Color color = Colors.redAccent;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  @override
  void dispose() {
    super.dispose();
    animation.removeListener(() {});
    controller.dispose();
  }

  void init() async {
    controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = ColorTween(begin: Colors.red, end: Colors.pink.shade900).animate(controller);

    controller.forward();
    setStatusBarColor(Colors.transparent);

    RegisterUserModel registerUser = RegisterUserModel();

    registerUser.photoURL = RegisterUserModel.getUserImage();
    registerUser.displayName = RegisterUserModel.getUserDisplayName();
    registerUser.email = RegisterUserModel.getUserEmail();
    registerUser.uid = RegisterUserModel.getUserUID();
    registerUser.isUserLogin = RegisterUserModel.getUserLoginStatus();

    registerUser.save(isLogin: RegisterUserModel.getUserLoginStatus());

    afterBuildCreated(() async {
      if (registerUser.isUserLogin) {
        await common(context).updateOneSignalUserId();
        await UserListScreen().launch(context, isNewTask: true);
      } else {
        await LoginScreen().launch(context, isNewTask: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Pillu", style: boldTextStyle(size: 28, color: color)),
      ),
    );
  }
}
