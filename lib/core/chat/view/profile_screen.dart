import 'package:example/common/component/button_component.dart';
import 'package:example/common/component/decoration.dart';
import 'package:example/core/auth/auth_api.dart';
import 'package:example/core/chat/chat_api.dart';
import 'package:example/core/chat/model/register_response.dart';
import 'package:example/core/chat/model/register_user_model.dart';
import 'package:example/model/src/user.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  ProfileScreen({super.key, this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RegisterResponse registerResponse = RegisterResponse();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    firstnameController.text = RegisterUserModel.getUserDisplayName();
    emailController.text = RegisterUserModel.getUserEmail();
    registerResponse = await getUserInfo(firebaseUserId: widget.user!.id.validate());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user != null) {
      return Scaffold(
        appBar: appBarWidget('Profile', elevation: 0),
        body: AnimatedScrollView(
          children: [
            16.height,
            if (widget.user!.imageUrl.validate().isNotEmpty)
              CircleAvatar(
                radius: context.width() * 0.2,
                backgroundImage: NetworkImage(widget.user!.imageUrl.validate()),
              ).center(),
            AnimatedScrollView(
              padding: EdgeInsets.all(16),
              children: [
                16.height,
                AppTextField(
                  controller: TextEditingController(text: widget.user?.firstName.validate()),
                  textFieldType: TextFieldType.NAME,
                  enabled: false,
                  decoration: inputDecorationField(labelText: 'User Name'),
                ),
                if (((registerResponse.data?.userProfile?.firstname.validate().isNotEmpty ?? false) && !(registerResponse.data?.userProfile?.firstname.validate() == '-')) ?? false)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      16.height,
                      AppTextField(
                        controller: TextEditingController(text: registerResponse.data?.userProfile?.firstname.validate()),
                        textFieldType: TextFieldType.NAME,
                        enabled: false,
                        decoration: inputDecorationField(labelText: 'First Name'),
                      ),
                    ],
                  ),
                if (((registerResponse.data?.userProfile?.lastname.validate().isNotEmpty ?? false) && !(registerResponse.data?.userProfile?.lastname.validate() == '-')) ?? false)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      16.height,
                      AppTextField(
                        controller: TextEditingController(text: registerResponse.data?.userProfile?.lastname.validate()),
                        textFieldType: TextFieldType.NAME,
                        enabled: false,
                        decoration: inputDecorationField(labelText: 'Last name'),
                      ),
                    ],
                  ),
                if (((registerResponse.data?.userProfile?.email.validate().isNotEmpty ?? false) && !(registerResponse.data?.userProfile?.email.validate() == '-')) ?? false)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      16.height,
                      AppTextField(
                        controller: TextEditingController(text: registerResponse.data?.userProfile?.email.validate()),
                        textFieldType: TextFieldType.NAME,
                        enabled: false,
                        decoration: inputDecorationField(labelText: 'Email'),
                      ),
                    ],
                  ),
                16.height,
                PilluButton(
                  text: 'Chat',
                  onTap: () {
                    launchChat(widget.user!, context);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: appBarWidget('Profile', elevation: 0),
      body: AnimatedScrollView(
        children: [
          16.height,
          CircleAvatar(
            radius: context.width() * 0.2,
            backgroundImage: NetworkImage(RegisterUserModel.getUserImage()),
          ).center(),
          AnimatedScrollView(
            padding: EdgeInsets.all(16),
            children: [
              16.height,
              AppTextField(
                controller: firstnameController,
                textFieldType: TextFieldType.NAME,
                enabled: false,
                decoration: inputDecorationField(
                  labelText: 'User Name',
                ),
              ),
              16.height,
              AppTextField(
                controller: emailController,
                textFieldType: TextFieldType.EMAIL,
                enabled: false,
                decoration: inputDecorationField(
                  labelText: 'Email',
                ),
              ),
              16.height,
              PilluButton(
                text: 'Edit',
                onTap: () {
                  toast("Under-Construction");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
