import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getPrefs(String data) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(data);
  }

  static clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static setPrefs(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data);
  }
}
