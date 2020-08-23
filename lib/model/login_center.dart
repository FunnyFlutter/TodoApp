import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String preferenceKey = 'todo_app_login_key';

class LoginCenter {
  LoginCenter._();

  static LoginCenter _instance = LoginCenter._();
  SharedPreferences _sharedPreferences;

  factory LoginCenter.instance() => _instance;

  Future<void> logout() async {
    await _initSharedPreferences();
    await _sharedPreferences.remove(preferenceKey);
  }

  Future<String> currentUserKey() async {
    await _initSharedPreferences();
    if (_sharedPreferences.containsKey(preferenceKey)) {
      return _sharedPreferences.getString(preferenceKey);
    }
    return '';
  }

  Future<String> login(String email) async {
    await _initSharedPreferences();
    String emailKey = sha256.convert(utf8.encode(email)).toString();
    await _sharedPreferences.setString(preferenceKey, emailKey);
    return emailKey;
  }

  Future<void> _initSharedPreferences() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }
}
