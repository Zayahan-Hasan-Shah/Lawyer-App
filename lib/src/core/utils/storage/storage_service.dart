import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Private constants for keys
  static const String _forgotEmailKey = 'forgot_email';
  static const String _accessTokenKey = 'access_token';

  // Singleton pattern (optional but recommended)
  StorageService._();
  static final StorageService instance = StorageService._();

  // ======================================================
  // Forgot Email Storage
  // ======================================================
  Future<void> saveForgotEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_forgotEmailKey, email.trim());
      log('Forgot email saved successfully: $email');
    } catch (e) {
      log('Error saving forgot email: $e', error: e);
    }
  }

  Future<String?> getForgotEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_forgotEmailKey);
      log('Retrieved forgot email: $email');
      return email;
    } catch (e) {
      log('Error retrieving forgot email: $e', error: e);
      return null;
    }
  }

  Future<void> deleteForgotEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final removed = await prefs.remove(_forgotEmailKey);
      if (removed) {
        log('Forgot email deleted successfully.');
      }
    } catch (e) {
      log('Error deleting forgot email: $e', error: e);
    }
  }

  // ======================================================
  // Access Token Storage
  // ======================================================
  Future<void> saveAccessToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, token.trim());
      log('Access token saved successfully.');
    } catch (e) {
      log('Error saving access token: $e', error: e);
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_accessTokenKey);
      if (token != null) {
        log('Access token retrieved successfully.');
      } else {
        log('No access token found in storage.');
      }
      return token;
    } catch (e) {
      log('Error retrieving access token: $e', error: e);
      return null;
    }
  }

  Future<void> deleteAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final removed = await prefs.remove(_accessTokenKey);
      if (removed) {
        log('Access token deleted successfully (user logged out).');
      }
    } catch (e) {
      log('Error deleting access token: $e', error: e);
    }
  }

  // Optional: Clear all auth data (useful for logout)
  Future<void> clearAllAuthData() async {
    await deleteForgotEmail();
    await deleteAccessToken();
    log('All authentication data cleared.');
  }
}
