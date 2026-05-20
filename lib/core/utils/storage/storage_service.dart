import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Private constants for keys
  static const String _forgotEmailKey = 'forgot_email';
  static const String _accessTokenKey = 'access_token';
  static const String _userIdKey = 'user_id';
  static const String _userTypeKey = 'user_type';
  static const String _fullNameKey = 'full_name';
  static const String _expiresUtcKey = 'expires_utc';
  static const String _expiresLocalKey = 'expires_local';

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

  // ======================================================
  // Extra User Info Storage
  // ======================================================
  Future<void> saveUserId(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_userIdKey, id);
      log('User ID saved successfully: $id');
    } catch (e) {
      log('Error saving user ID: $e', error: e);
    }
  }

  Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_userIdKey);
    } catch (e) {
      log('Error retrieving user ID: $e', error: e);
      return null;
    }
  }

  Future<void> saveUserType(String? type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (type == null) {
        await prefs.remove(_userTypeKey);
      } else {
        await prefs.setString(_userTypeKey, type);
      }
      log('User Type saved successfully: $type');
    } catch (e) {
      log('Error saving user type: $e', error: e);
    }
  }

  Future<String?> getUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userTypeKey);
    } catch (e) {
      log('Error retrieving user type: $e', error: e);
      return null;
    }
  }

  Future<void> saveFullName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_fullNameKey, name);
      log('Full Name saved successfully: $name');
    } catch (e) {
      log('Error saving full name: $e', error: e);
    }
  }

  Future<String?> getFullName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_fullNameKey);
    } catch (e) {
      log('Error retrieving full name: $e', error: e);
      return null;
    }
  }

  Future<void> saveExpiresUtc(String expires) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_expiresUtcKey, expires);
    } catch (e) {
      log('Error saving expires UTC: $e', error: e);
    }
  }

  Future<String?> getExpiresUtc() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_expiresUtcKey);
    } catch (e) {
      log('Error retrieving expires UTC: $e', error: e);
      return null;
    }
  }

  Future<void> saveExpiresLocal(String expires) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_expiresLocalKey, expires);
    } catch (e) {
      log('Error saving expires local: $e', error: e);
    }
  }

  Future<String?> getExpiresLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_expiresLocalKey);
    } catch (e) {
      log('Error retrieving expires local: $e', error: e);
      return null;
    }
  }

  // Clear all auth data (useful for logout)
  Future<void> clearAllAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_forgotEmailKey);
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userTypeKey);
      await prefs.remove(_fullNameKey);
      await prefs.remove(_expiresUtcKey);
      await prefs.remove(_expiresLocalKey);
      log('All authentication data cleared.');
    } catch (e) {
      log('Error clearing all auth data: $e', error: e);
    }
  }
}
