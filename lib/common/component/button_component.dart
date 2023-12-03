import 'package:example/common/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PilluButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const PilluButton({super.key, this.text = '', required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      width: context.width(),
      color: context.primaryColor,
      text: text,
      elevation: 0,
      textStyle: primaryTextStyle(color: context.cardColor, size: 14),
      height: PilluThemeData.globalActiveButtonHeight,
      shapeBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(PilluThemeData.globalActiveButtonRadius),
        borderSide: PilluThemeData.globalActiveButtonBoarderSide,
      ),
      onTap: onTap,
    );
  }
}
