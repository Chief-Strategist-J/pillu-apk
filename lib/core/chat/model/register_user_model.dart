import 'package:example/main.dart';
import 'package:nb_utils/nb_utils.dart';

const PHOTO_URL_KEY = 'PHOTO_URL';
const DISPLAY_NAME_KEY = 'DISPLAY_NAME';
const EMAIL_KEY = 'EMAIL';
const UID_KEY = 'UID';
const IS_USER_LOGIN_KEY = 'IS_USER_LOGIN';

class RegisterUserModel {
  String photoURL;
  String displayName;
  String email;
  String uid;
  bool isUserLogin;

  RegisterUserModel({
    this.photoURL = '',
    this.displayName = '',
    this.email = '',
    this.uid = '',
    this.isUserLogin = false,
  });

  void save({required bool isLogin}) {
    setUserDisplayName(this.displayName, persist: true);
    setUserEmail(this.email, persist: true);
    setUserImage(this.photoURL, persist: true);
    setUserLoginStatus(isLogin, persist: true);
    setUserUID(this.uid, persist: true);
  }

  static void initUser() {
    getUserDisplayName();
    getUserEmail();
    getUserImage();
    getUserLoginStatus();
    getUserUID();
  }

  void clearUserData() {
    setUserDisplayName('', persist: true);
    setUserEmail('', persist: true);
    setUserImage('', persist: true);
    setUserLoginStatus(false, persist: true);
    setUserUID('', persist: true);
  }

  void setUserImage(String userImage, {bool persist = false}) {
    this.photoURL = userImage;
    if (persist) {
      storage.setValue(key: PHOTO_URL_KEY, value: userImage);
    }
  }

  void setUserDisplayName(String userDisplayName, {bool persist = false}) {
    this.displayName = userDisplayName;
    if (persist) {
      storage.setValue(key: DISPLAY_NAME_KEY, value: userDisplayName);
    }
  }

  void setUserEmail(String userEmail, {bool persist = false}) {
    this.email = userEmail;
    if (persist) {
      storage.setValue(key: EMAIL_KEY, value: userEmail);
    }
  }

  void setUserUID(String userUid, {bool persist = false}) {
    this.uid = userUid;
    if (persist) {
      storage.setValue(key: UID_KEY, value: userUid);
    }
  }

  void setUserLoginStatus(bool status, {bool persist = false}) {
    this.isUserLogin = status;

    if (persist) {
      storage.setValue(key: IS_USER_LOGIN_KEY, value: status);
    }
  }

  static String getUserImage() {
    return storage.getValue<String>(key: PHOTO_URL_KEY).validate();
  }

  static String getUserDisplayName() {
    return storage.getValue<String>(key: DISPLAY_NAME_KEY).validate();
  }

  static String getUserEmail() {
    return storage.getValue<String>(key: EMAIL_KEY).validate();
  }

  static String getUserUID() {
    return storage.getValue<String>(key: UID_KEY).validate();
  }

  static bool getUserLoginStatus() {
    return storage.getValue<bool>(key: IS_USER_LOGIN_KEY).validate();
  }
}
