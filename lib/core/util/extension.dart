import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

extension StringExt on String {
  Widget showImage(
    BuildContext context, {
    double? width,
    double? height,
    Color? color,
    bool? hideColor,
    BoxFit? fit,
  }) {
    return Image.asset(
      this,
      width: width ?? 25,
      height: height ?? 25,
      color: (hideColor ?? false) ? null : (color ?? context.iconColor),
      fit: fit,
    );
  }
}
