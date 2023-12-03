import 'package:example/common/common_controller.dart';
import 'package:example/common/component/app_loader.dart';
import 'package:example/common/images.dart';

import 'package:example/core/auth/controller/auth_controller.dart';
import 'package:example/core/chat/model/register_user_model.dart';
import 'package:example/core/chat/view/user_list_screen.dart';

import 'package:example/firebase_chat_core/lib/flutter_firebase_chat_core.dart';
import 'package:example/model/src/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CommonController common(BuildContext context) => Provider.of<CommonController>(context, listen: false);

  String getDisplayName(auth.User _user) => _user.displayName.validate();

  String get getOneSignalToken => OneSignal.User.pushSubscription.token.validate(value: "12345678");

  String get getOneSignalID => OneSignal.User.pushSubscription.id.validate();

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      Provider.of<CommonController>(context, listen: false).setLoading(false);
    });
  }

  void logout() async {
    await auth.FirebaseAuth.instance.signOut();
  }

  void updateEmailOnOneSignal(auth.User? _user) {
    OneSignal.login(_user!.uid.validate());
    OneSignal.User.addEmail(_user.email.validate());
  }

  RegisterUserModel _saveFirebaseInfoLocally(auth.User? _user) {
    RegisterUserModel registerUser = RegisterUserModel();

    registerUser.isUserLogin = true;
    registerUser.photoURL = _user!.photoURL.validate();
    registerUser.displayName = getDisplayName(_user);
    registerUser.email = _user.email.validate();
    registerUser.uid = _user.uid.validate();

    registerUser.save(isLogin: true);

    return registerUser;
  }

  Future<void> _createAndUpdateUserOnFirebase(User _currUser, BuildContext context) async {
    await FirebaseChatCore.instance.createUserInFirestore(_currUser).then((value) async {
      await common(context).updateOneSignalUserId();

      common(context).setLoading(false);
      await UserListScreen().launch(context, isNewTask: true);
    }).catchError((e) {
      common(context).setLoading(false);
    });
  }

  Future<void> googleLogin(BuildContext context) async {
    common(context).setLoading(true);

    try {
      AuthController auth = AuthController();
      final credential = await auth.signInWithGoogle().catchError((e) {
        common(context).setLoading(false);
      });

      if (credential.user != null) {
        final _user = credential.user;
        _user!;
        RegisterUserModel registerUser = _saveFirebaseInfoLocally(_user);

        updateEmailOnOneSignal(_user);

        /// What If User Already Exist?

        await common(context).registerUserInfo(
          displayName: getDisplayName(_user),
          userName: getDisplayName(_user),
          firstname: "-",
          lastname: "-",
          password: "12345678",
          email: _user.email.validate(),
          photoUrl: _user.photoURL.validate(),
          firebaseUserId: registerUser.uid.validate(),
          onesignalSubscriptionId: getOneSignalID,
          onesignalUserToken: getOneSignalToken,
          onesignalExternalId: registerUser.uid.validate(),
        );

        User _currUser = User(
          firstName: credential.user!.displayName,
          id: credential.user!.uid,
          imageUrl: _user.photoURL.validate(),
          lastName: '-',
        );

        await _createAndUpdateUserOnFirebase(_currUser, context);
      }
    } on Exception catch (e) {
      common(context).setLoading(false);
      toast("Something Went Wrong - $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Greetings to Pillu!', elevation: 0),
      body: Stack(
        children: [
          Selector<CommonController, bool>(
            selector: (context, provider) {
              return provider.isLoading;
            },
            builder: (context, value, child) {
              if (value) {
                return Offstage();
              } else {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    await googleLogin(context);
                  },
                  child: CircleAvatar(
                    radius: context.width() * 0.38,
                    backgroundImage: AssetImage(imgGoogleImg),
                    backgroundColor: context.primaryColor,
                    child: Container(
                      height: context.width() * 0.34,
                      width: context.width() * 0.34,
                      alignment: Alignment.center,
                      child: Text('Continue', style: boldTextStyle(color: context.cardColor)),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.primaryColor,
                        borderRadius: BorderRadius.circular(300),
                        border: Border.all(color: context.cardColor, width: 0.3),
                      ),
                    ),
                  ),
                );
              }
            },
          ).center(),
          AppLoader().center(),
        ],
      ),
    );
  }
}
