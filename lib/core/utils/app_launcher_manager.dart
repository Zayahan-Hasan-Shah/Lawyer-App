import 'package:shared_preferences/shared_preferences.dart';

class AppLaunchManager {
  static const String _keyFirstLaunch = "is_first_launch";


  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool(_keyFirstLaunch) ?? true;
    if (isFirst) {
      await prefs.setBool(_keyFirstLaunch, false); 
    }
    return isFirst;
  }
}