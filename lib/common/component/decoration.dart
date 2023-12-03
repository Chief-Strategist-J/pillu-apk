import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

InputDecoration inputDecorationField({
  Widget? suffixIcon,
  String labelText = '',
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: primaryTextStyle(size: 12, color: Color(0xFF061E56)),
    suffixIcon: suffixIcon,
    alignLabelWithHint: true,
    contentPadding: EdgeInsets.only(top: 8, left: 16),
  );
}
