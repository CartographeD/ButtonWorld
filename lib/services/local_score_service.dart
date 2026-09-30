import 'package:shared_preferences/shared_preferences.dart';

class LocalScoreService {
  static const String _pressesKey = 'presses';
  static const String _bestTapStreakKey = 'best_tap_streak';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _hapticsEnabledKey = 'haptics_enabled';
  static const String _buttonSkinKey = 'button_skin';

  static Future<int> getPresses() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pressesKey) ?? 0;
  }

  static Future<void> savePresses(int presses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pressesKey, presses);
  }

  static Future<int> getBestTapStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bestTapStreakKey) ?? 0;
  }

  static Future<void> saveBestTapStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bestTapStreakKey, streak);
  }

  static Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEnabledKey) ?? true;
  }

  static Future<void> saveSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }

  static Future<bool> getHapticsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hapticsEnabledKey) ?? true;
  }

  static Future<void> saveHapticsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsEnabledKey, enabled);
  }

  static Future<String> getButtonSkin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_buttonSkinKey) ?? 'classic';
  }

  static Future<void> saveButtonSkin(String skin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_buttonSkinKey, skin);
  }
}
