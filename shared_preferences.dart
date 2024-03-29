// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPreferencesHelper {
//
//   static Future<void> saveData(String key, String value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(key, value);
//   }
//
//   static Future<String?> getData(String key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key);
//   }
//
//   static Future<void> clearData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
// }
