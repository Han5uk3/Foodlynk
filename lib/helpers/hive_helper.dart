import 'package:saver_bbk_main/main.dart';

class HiveHelper {
  static const String userLanguageKey = 'user_language';
  static putUID(String uid) {
    return MyApp.box.put('uid', uid);
  }

  static putisGuest(bool isTrue) {
    return MyApp.box.put('isGuest', isTrue);
  }

  static getUID() {
    return MyApp.box.get('uid');
  }

  static getIsGuest() {
    return MyApp.box.get('isGuest', defaultValue: false);
  }

  static removeUID() {
    return MyApp.box.delete('uid');
  }

  static removeIsGuest() {
    return MyApp.box.delete('isGuest');
  }

  putUserlanguage(String lang) async {
    await MyApp.box.put('user_language', lang);
    await MyApp.box.flush();
    return lang;
  }

  String getUserlanguage() {
    return MyApp.box.get('user_language', defaultValue: 'en');
  }
}
