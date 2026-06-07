import 'dart:developer';

import 'package:lawyer_app/core/constants/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Singleton pattern
  StorageService._();
  static final StorageService instance = StorageService._();

  // Generic methods
  Future<void> write(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<dynamic>? read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get(key);
    return value;
  }

  Future<void> delete(String key) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Clear all auth data (useful for logout)
  Future<void> clearAllAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppKeys.forgotEmailKey);
      await prefs.remove(AppKeys.accessTokenKey);
      await prefs.remove(AppKeys.userIdKey);
      await prefs.remove(AppKeys.userTypeKey);
      await prefs.remove(AppKeys.fullNameKey);
      await prefs.remove(AppKeys.expiresUtcKey);
      await prefs.remove(AppKeys.expiresLocalKey);
      log('All authentication data cleared.');
    } catch (e) {
      log('Error clearing all auth data: $e', error: e);
    }
  }
}
