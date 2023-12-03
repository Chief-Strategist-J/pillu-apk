import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Future<void> showWarningDialog(BuildContext context, {required String error}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(error, style: primaryTextStyle()),
        title: Text('Error'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              finish(context);
            },
          ),
        ],
      );
    },
  );
}
