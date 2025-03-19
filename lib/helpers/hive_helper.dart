import 'package:saver_bbk_main/main.dart';

class HiveHelper {
  static putUID(String uid) {
    return MyApp.box.put('uid', uid);
  }

  static getUID() {
    return MyApp.box.get('uid');
  }
}
