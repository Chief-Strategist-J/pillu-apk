import 'package:example/core/chat/model/register_response.dart';
import 'package:example/core/util/service/network/network_utils.dart';

Future<RegisterResponse> getUserInfo({required String firebaseUserId}) async {
  Map<String, dynamic> request = {"firebase_user_id": firebaseUserId};
  return RegisterResponse.fromJson(await NetworkService().call('api/getUserDetail', request: request, method: MethodType.POST));
}
