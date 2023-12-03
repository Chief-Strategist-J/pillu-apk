class OnesignalSubscriptionUpdatedResponse {
  OnesignalSubscriptionUpdatedResponse({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  OnesignalSubscriptionUpdatedResponse.fromJson(dynamic json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? OneSignalData.fromJson(json['data']) : null;
  }

  bool? status;
  String? error;
  String? message;
  OneSignalData? data;

  OnesignalSubscriptionUpdatedResponse copyWith({
    bool? status,
    String? error,
    String? message,
    OneSignalData? data,
  }) =>
      OnesignalSubscriptionUpdatedResponse(
        status: status ?? this.status,
        error: error ?? this.error,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['error'] = error;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class OneSignalData {
  OneSignalData({
    this.email,
    this.onesignalSubscriptionId,
  });

  OneSignalData.fromJson(dynamic json) {
    email = json['email'];
    onesignalSubscriptionId = json['onesignal_subscription_id'];
  }

  String? email;
  String? onesignalSubscriptionId;

  OneSignalData copyWith({
    String? email,
    String? onesignalSubscriptionId,
  }) =>
      OneSignalData(
        email: email ?? this.email,
        onesignalSubscriptionId: onesignalSubscriptionId ?? this.onesignalSubscriptionId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['onesignal_subscription_id'] = onesignalSubscriptionId;
    return map;
  }
}
