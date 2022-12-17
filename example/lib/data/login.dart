import 'package:shared_preferences/shared_preferences.dart';

class Login {
  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("login") ?? false;
  }

  static Future<bool> login() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool("login", true);
  }

  static Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove("login");
  }
}
