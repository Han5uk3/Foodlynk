import 'package:saver_bbk_main/main.dart';

class HiveHelper {
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
    return MyApp.box.get('isGuest');
  }

  static removeUID() {
    return MyApp.box.delete('uid');
  }
}
