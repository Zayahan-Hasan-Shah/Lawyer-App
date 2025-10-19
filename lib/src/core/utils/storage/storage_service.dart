import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _forgotEmail = 'forgot_email';

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
}
