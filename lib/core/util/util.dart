import 'dart:ui';

import 'package:example/model/src/user.dart';
import 'package:nb_utils/nb_utils.dart';

const emailTemplate = ""
    "\n\nDear [Recipient's Name],\n\n"
    "I hope this email finds you well\n\nI am writing to [purpose of the email]\n[Include any necessary details or context here.]\n\n"
    "[Additional information or main body of the email can be included here.]\n\n"
    "If you have any questions or concerns, please feel free to reach out to me.\n\n I appreciate your [time/attention/help] on this matter."
    "\n\nThank you and best regards,\n"
    "[Your Name]\n"
    "[Your Position]\n"
    "[Your Company]\n"
    "[Your Contact Information]\n";

const colors = [
  Color(0xffff6767),
  Color(0xff66e0da),
  Color(0xfff5a2d9),
  Color(0xfff0c722),
  Color(0xff6a85e5),
  Color(0xfffd9a6f),
  Color(0xff92db6e),
  Color(0xff73b8e5),
  Color(0xfffd7590),
  Color(0xffc78ae5),
];

Color getUserAvatarNameColor(User user) {
  final index = user.id.hashCode % colors.length;
  return colors[index];
}

String getUserName(User user) => '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim().capitalizeEachWord();
