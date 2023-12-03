import 'dart:convert';

import 'package:example/common/common_controller.dart';
import 'package:example/core/chat/model/onesignal_subscription_updated_response.dart';
import 'package:example/core/chat/model/register_user_model.dart';
import 'package:example/core/util/config.dart';
import 'package:example/core/util/service/network/network_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

void notificationMessage({required String id, required String message}) async {
  Uri url = Uri.parse('https://onesignal.com/api/v1/notifications');

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Authorization': 'Basic $OneSignalRestAPIKey',
  };

  String body = jsonEncode({
    "app_id": OneSignalAppID,
    "data": {},
    "contents": {"en": message},
    "include_subscription_ids": [id],
  });

  try {
    Response response = await post(url, headers: headers, body: body);

    (response.statusCode == 200) ? log(response.body) : log(response.reasonPhrase);
  } catch (e) {
    log('Error: $e');
  }
}
