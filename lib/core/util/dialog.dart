import 'package:example/common/component/decoration.dart';
import 'package:example/common/theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

bool isGoogleAuth() {
  return FirebaseAuth.instance.currentUser!.providerData[0].providerId.toLowerCase().contains('google');
}

void showCustomDialog(BuildContext context) {
  TextEditingController _textFieldController = TextEditingController();

  final _globalKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              autovalidateMode: AutovalidateMode.always,
              key: _globalKey,
              child: GestureDetector(
                onTap: () {
                  if (isGoogleAuth()) {
                    toast("You Can't Change Password For Google Sign-In");
                  }
                },
                child: AppTextField(
                  textFieldType: TextFieldType.NAME,
                  controller: _textFieldController,
                  enabled: isGoogleAuth() ? false : true,
                  decoration: inputDecorationField(
                    labelText: 'New-Password',
                  ),
                ),
              ),
            ),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  elevation: 0,
                  color: context.primaryColor,
                  padding: EdgeInsets.zero,

                  // width: context.width() * 0.15,
                  height: PilluThemeData.globalActiveButtonHeight * 0.8,
                  child: Text('Yes', style: primaryTextStyle(color: context.cardColor, size: 14)),
                  onTap: () async {
                    if (_globalKey.currentState!.validate()) {
                      String enteredText = _textFieldController.text;
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      final _providerData = _auth.currentUser!.providerData;

                      if (_providerData[0].providerId.toLowerCase().contains('google')) {
                        toast("You Can't Change Password For Google Sign-In");
                        finish(context);
                      } else {
                        await _auth.currentUser!.updatePassword(enteredText);
                        toast('Password Is Updated Successfully');
                        finish(context);
                      }
                    } else {
                      //
                    }
                  },
                ),
                16.width,
                AppButton(
                  elevation: 0,
                  color: context.cardColor,
                  padding: EdgeInsets.zero,
                  shapeBorder: OutlineInputBorder(borderSide: BorderSide(color: context.dividerColor, width: 1)),
                  // width: context.width() * 0.15,
                  height: PilluThemeData.globalActiveButtonHeight * 0.8,
                  child: Text('No', style: primaryTextStyle(color: context.primaryColor, size: 14)),
                  onTap: () {
                    finish(context);
                  },
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
