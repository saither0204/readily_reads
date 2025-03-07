import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:readily_reads/book_model.dart';

// User model class
class User {
  final int? id;
  final String username;
  final String password; // In a real app, this should be hashed

  User({
    this.id,
    required this.username,
    required this.password,
  });

  // Convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password, // Should be hashed in production
    };
  }

  // Create User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username}';
  }
}

// Database helper class
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Using the BookDatabaseHelper to ensure we're working with the same database
  final BookDatabaseHelper _bookDbHelper = BookDatabaseHelper();

  // Get database instance, which is now managed by BookDatabaseHelper
  Future<Database> get database async {
    return await _bookDbHelper.database;
  }

  // Insert a user into the database
  Future<int> insertUser(User user) async {
    try {
      final Database db = await database;
      if (kDebugMode) {
        print('Inserting user: ${user.username}');
      }
      return await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting user: $e');
      }
      rethrow;
    }
  }

  // Get a user by username
  Future<User?> getUserByUsername(String username) async {
    try {
      final Database db = await database;
      List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (maps.isNotEmpty) {
        if (kDebugMode) {
          print('Found user: $username');
        }
        return User.fromMap(maps.first);
      }
      if (kDebugMode) {
        print('No user found with username: $username');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user by username: $e');
      }
      rethrow;
    }
  }

  // Authenticate a user
  Future<bool> authenticateUser(String username, String password) async {
    try {
      User? user = await getUserByUsername(username);
      if (user != null && user.password == password) {
        if (kDebugMode) {
          print('User authenticated: $username');
        }
        return true;
      }
      if (kDebugMode) {
        print('Authentication failed for user: $username');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error authenticating user: $e');
      }
      return false;
    }
  }
}
