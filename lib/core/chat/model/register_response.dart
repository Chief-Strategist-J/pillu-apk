import 'package:nb_utils/nb_utils.dart';

class RegisterResponse {
  RegisterResponse({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  RegisterResponse.fromJson(dynamic json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? RegisterData.fromJson(json['data']) : null;
  }

  bool? status;
  String? error;
  String? message;
  RegisterData? data;

  RegisterResponse copyWith({
    bool? status,
    String? error,
    String? message,
    RegisterData? data,
  }) =>
      RegisterResponse(
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

class RegisterData {
  RegisterData({
    this.id,
    this.userProfile,
    this.onesignalUserProfile,
  });

  RegisterData.fromJson(dynamic json) {
    id = json['id'];
    userProfile = json['user_profile'] != null ? UserProfile.fromJson(json['user_profile']) : null;
    onesignalUserProfile = json['onesignal_user_profile'] != null ? OnesignalUserProfile.fromJson(json['onesignal_user_profile']) : null;
  }

  num? id;
  UserProfile? userProfile;
  OnesignalUserProfile? onesignalUserProfile;

  RegisterData copyWith({
    num? id,
    UserProfile? userProfile,
    OnesignalUserProfile? onesignalUserProfile,
  }) {
    return RegisterData(
      id: id ?? this.id,
      userProfile: userProfile ?? this.userProfile,
      onesignalUserProfile: onesignalUserProfile ?? this.onesignalUserProfile,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (userProfile != null) {
      map['user_profile'] = userProfile?.toJson();
    }
    if (onesignalUserProfile != null) {
      map['onesignal_user_profile'] = onesignalUserProfile?.toJson();
    }
    return map;
  }
}

class OnesignalUserProfile {
  OnesignalUserProfile({
    this.id,
    this.userId,
    this.onesignalSubscriptionId,
    this.onesignalEmail,
    this.onesignalUserToken,
    this.onesignalExternalId,
  });

  OnesignalUserProfile.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    onesignalSubscriptionId = json['onesignal_subscription_id'];
    onesignalEmail = json['onesignal_email'];
    onesignalUserToken = json['onesignal_user_token'];
    onesignalExternalId = json['onesignal_external_id'];
  }

  num? id;
  num? userId;
  String? onesignalSubscriptionId;
  String? onesignalEmail;
  String? onesignalUserToken;
  String? onesignalExternalId;

  OnesignalUserProfile copyWith({
    num? id,
    num? userId,
    String? onesignalSubscriptionId,
    String? onesignalEmail,
    String? onesignalUserToken,
    String? onesignalExternalId,
  }) =>
      OnesignalUserProfile(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        onesignalSubscriptionId: onesignalSubscriptionId ?? this.onesignalSubscriptionId,
        onesignalEmail: onesignalEmail ?? this.onesignalEmail,
        onesignalUserToken: onesignalUserToken ?? this.onesignalUserToken,
        onesignalExternalId: onesignalExternalId ?? this.onesignalExternalId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['onesignal_subscription_id'] = onesignalSubscriptionId;
    map['onesignal_email'] = onesignalEmail;
    map['onesignal_user_token'] = onesignalUserToken;
    map['onesignal_external_id'] = onesignalExternalId;
    return map;
  }
}

class UserProfile {
  UserProfile({
    this.id,
    this.userId,
    this.photoUrl,
    this.email,
    this.userName,
    this.firebaseUserId,
    this.firstname,
    this.lastname,
  });

  UserProfile.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    photoUrl = json['photoUrl'];
    email = json['email'];
    userName = json['userName'];
    firebaseUserId = json['firebase_user_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
  }

  num? id;
  num? userId;
  String? photoUrl;
  String? email;
  String? userName;
  String? firebaseUserId;
  String? firstname;
  String? lastname;

  UserProfile copyWith({
    num? id,
    num? userId,
    String? photoUrl,
    String? email,
    String? userName,
    String? firebaseUserId,
    String? firstname,
    String? lastname,
  }) =>
      UserProfile(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        photoUrl: photoUrl ?? this.photoUrl,
        email: email ?? this.email,
        userName: userName ?? this.userName,
        firebaseUserId: firebaseUserId ?? this.firebaseUserId,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['photoUrl'] = photoUrl;
    map['email'] = email;
    map['userName'] = userName;
    map['firebase_user_id'] = firebaseUserId;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    return map;
  }
}
