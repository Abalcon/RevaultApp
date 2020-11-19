import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String _session;

  String get session => _session;

  // 로그인하여 Session 받기
  set session(String newSession) {
    assert(newSession != null);
    _session = newSession;
    notifyListeners();
  }

  // 로그아웃하여 Session 파기
  void removeSession() {
    _session = null;
    notifyListeners();
  }
}