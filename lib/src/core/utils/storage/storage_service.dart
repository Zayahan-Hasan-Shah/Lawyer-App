import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _forgotEmail = 'forgot_email';
  static const _accessToken = 'access_token';

  // ======================================================
  // Email Storage
  // ======================================================
  Future<void> saveForgotEnail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_forgotEmail, email);
    } catch (e) {
      log('Error saving forogot email: $e', error: e);
    }
  }

  Future<String?> getForgotEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_forgotEmail);
    } catch (e) {
      log('Error retrieving forgot email: $e', error: e);
      return null;
    }
  }

  Future<void> deleteForgotEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_forgotEmail);
      log('Forgot email deleted successfully.');
    } catch (e) {
      log('Error deleting forgot email: $e', error: e);
    }
  }

  // ======================================================
  // Token Storage
  // ======================================================
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", token);
    } catch (e) {
      log('Error while saving token: $e', error: e);
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accessToken);
    } catch (e) {
      log('Error retrieving forgot email: $e', error: e);
      return null;
    }
  }

  Future<void> deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessToken);
      log('Token deleted successfully.');
    } catch (e) {
      log('Error deleting token: $e', error: e);
    }
  }
}
