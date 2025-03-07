import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

  static Database? _database;

  // Get database instance, creating it if it doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'login_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  // Create tables in the database
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  // Insert a user into the database
  Future<int> insertUser(User user) async {
    final Database db = await database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get a user by username
  Future<User?> getUserByUsername(String username) async {
    final Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Authenticate a user
  Future<bool> authenticateUser(String username, String password) async {
    User? user = await getUserByUsername(username);
    if (user != null && user.password == password) {
      return true;
    }
    return false;
  }
}

// Example usage in a login page
class LoginService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Register a new user
  Future<bool> registerUser(String username, String password) async {
    try {
      User newUser = User(username: username, password: password);
      await _dbHelper.insertUser(newUser);
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Login a user
  Future<bool> loginUser(String username, String password) async {
    return await _dbHelper.authenticateUser(username, password);
  }
}