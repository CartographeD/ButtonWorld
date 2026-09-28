import 'package:shared_preferences/shared_preferences.dart';

class LocalScoreService {
  static const String _pressesKey = 'presses';

  static Future<int> getPresses() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_pressesKey) ?? 0;
  }

  static Future<void> savePresses(int presses) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_pressesKey, presses);
  }
}