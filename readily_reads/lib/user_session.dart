import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';

  // Save user session data
  static Future<bool> saveUserSession(int userId, String username) async {
    try {
      if (kDebugMode) {
        print('UserSession: Saving session for user $username (ID: $userId)');
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_userIdKey, userId);
      await prefs.setString(_usernameKey, username);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user session: $e');
      }
      return false;
    }
  }

  // Get current user ID
  static Future<int?> getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt(_userIdKey);
      if (kDebugMode) {
        print('UserSession: Current user ID: $userId');
      }
      return userId;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user ID: $e');
      }
      return null;
    }
  }

  // Get current username
  static Future<String?> getCurrentUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString(_usernameKey);
      if (kDebugMode) {
        print('UserSession: Current username: $username');
      }
      return username;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting username: $e');
      }
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.containsKey(_userIdKey);
      if (kDebugMode) {
        print('UserSession: Is user logged in? $isLoggedIn');
      }
      return isLoggedIn;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking login status: $e');
      }
      return false;
    }
  }

  // Clear user session (logout)
  static Future<bool> clearSession() async {
    try {
      if (kDebugMode) {
        print('UserSession: Clearing user session');
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.remove(_usernameKey);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing session: $e');
      }
      return false;
    }
  }
}
