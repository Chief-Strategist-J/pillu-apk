import 'package:example/core/chat/model/onesignal_subscription_updated_response.dart';
import 'package:example/core/chat/model/register_response.dart';
import 'package:example/core/chat/model/register_user_model.dart';
import 'package:example/core/util/service/network/network_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class CommonController extends ChangeNotifier {
  bool isLoading = false;

  void setLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  Future<OnesignalSubscriptionUpdatedResponse> updateOneSignalUserId() async {
    try {
      Map<String, dynamic> request = {"onesignal_subscription_id": OneSignal.User.pushSubscription.id, "email": RegisterUserModel.getUserEmail()};
      final res = await NetworkService().call('api/updateOnesignalSubcriptionId', request: request, method: MethodType.POST);
      setLoading(false);
      return OnesignalSubscriptionUpdatedResponse.fromJson(res);
    } on Exception catch (e) {
      setLoading(false);
      throw e;
    }
  }

  Future<RegisterResponse> registerUserInfo({
    required String displayName,
    required String userName,
    required String firstname,
    required String lastname,
    required String password,
    required String email,
    required String photoUrl,
    required String firebaseUserId,
    required String onesignalSubscriptionId,
    required String onesignalUserToken,
    required String onesignalExternalId,
  }) async {
    Map<String, dynamic> request = {
      "name": userName,
      "email": email,
      "photoUrl": photoUrl,
      "userName": displayName,
      "firebase_user_id": firebaseUserId,
      "firstname": firstname,
      "lastname": lastname,
      "password": password,
      "onesignal_subscription_id": onesignalSubscriptionId,
      "onesignal_user_token": onesignalUserToken,
      "onesignal_external_id": onesignalExternalId,
    };
    try {
      final res = await NetworkService().call('api/registerUser', request: request, method: MethodType.POST);
      setLoading(false);
      return RegisterResponse.fromJson(res);
    } on Exception catch (e) {
      setLoading(false);
      throw e;
    }
  }
}
