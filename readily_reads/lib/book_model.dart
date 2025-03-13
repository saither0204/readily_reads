import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Book model class
class Book {
  final int? id;
  final String title;
  final String author;
  final String genre;
  final int? pages;
  final String? description;
  final DateTime? publicationDate;
  final bool isCurrentlyReading;
  final int? userId; // Reference to the user who owns this book

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    this.pages,
    this.description,
    this.publicationDate,
    this.isCurrentlyReading = false,
    this.userId,
  });

  // Convert Book object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'pages': pages,
      'description': description,
      'publicationDate': publicationDate?.millisecondsSinceEpoch,
      'isCurrentlyReading': isCurrentlyReading ? 1 : 0,
      'userId': userId,
    };
  }

  // Create Book object from a Map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      genre: map['genre'],
      pages: map['pages'],
      description: map['description'],
      publicationDate: map['publicationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['publicationDate'])
          : null,
      isCurrentlyReading: map['isCurrentlyReading'] == 1,
      userId: map['userId'],
    );
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, genre: $genre}';
  }
}

// Database helper class for books
class BookDatabaseHelper {
  static final BookDatabaseHelper _instance = BookDatabaseHelper._internal();
  factory BookDatabaseHelper() => _instance;
  BookDatabaseHelper._internal();

  static Database? _database;

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'readily_reads_database.db');
      if (kDebugMode) {
        print('Database path: $path');
      }

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDb,
        onUpgrade: _upgradeDb,
        onOpen: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
          if (kDebugMode) {
            print('Database opened successfully');
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing database: $e');
      }
      rethrow;
    }
  }

  // Create database tables
  Future<void> _createDb(Database db, int version) async {
    try {
      if (kDebugMode) {
        print('Creating database tables...');
      }

      // Create users table if it doesn't exist
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE,
          password TEXT
        )
      ''');

      // Create books table if it doesn't exist
      await db.execute('''
        CREATE TABLE IF NOT EXISTS books(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          author TEXT NOT NULL,
          genre TEXT NOT NULL,
          pages INTEGER,
          description TEXT,
          publicationDate INTEGER,
          isCurrentlyReading INTEGER DEFAULT 0,
          userId INTEGER,
          FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');

      if (kDebugMode) {
        print('Database tables created successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating database tables: $e');
      }
      rethrow;
    }
  }

  // Upgrade database if needed
  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    try {
      if (kDebugMode) {
        print('Upgrading database from $oldVersion to $newVersion');
      }

      if (oldVersion < newVersion) {
        // Add logic for database migrations here if needed in future
        // For example, adding new columns to existing tables
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error upgrading database: $e');
      }
      rethrow;
    }
  }

  // Insert a book
  Future<int> insertBook(Book book) async {
    try {
      final Database db = await database;
      if (kDebugMode) {
        print('Inserting book: ${book.title}');
      }
      return await db.insert(
        'books',
        book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting book: $e');
      }
      rethrow;
    }
  }

  // Get all books for a user
  Future<List<Book>> getBooksForUser(int userId) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'books',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      if (kDebugMode) {
        print('Found ${maps.length} books for user $userId');
      }

      return List.generate(maps.length, (i) {
        return Book.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting books for user: $e');
      }
      rethrow;
    }
  }

  // Get a single book by id
  Future<Book?> getBookById(int id) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'books',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Book.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting book by id: $e');
      }
      rethrow;
    }
  }

  // Get books by author
  Future<List<Book>> getBooksByAuthor(String author, int userId) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'books',
        where: 'author = ? AND userId = ?',
        whereArgs: [author, userId],
      );

      return List.generate(maps.length, (i) {
        return Book.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting books by author: $e');
      }
      rethrow;
    }
  }

  // Get books by genre
  Future<List<Book>> getBooksByGenre(String genre, int userId) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'books',
        where: 'genre = ? AND userId = ?',
        whereArgs: [genre, userId],
      );

      return List.generate(maps.length, (i) {
        return Book.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting books by genre: $e');
      }
      rethrow;
    }
  }

  // Get currently reading books
  Future<List<Book>> getCurrentlyReadingBooks(int userId) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'books',
        where: 'isCurrentlyReading = 1 AND userId = ?',
        whereArgs: [userId],
      );

      if (kDebugMode) {
        print('Found ${maps.length} currently reading books for user $userId');
      }

      return List.generate(maps.length, (i) {
        return Book.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting currently reading books: $e');
      }
      rethrow;
    }
  }

  // Update a book
  Future<int> updateBook(Book book) async {
    try {
      final Database db = await database;
      if (kDebugMode) {
        print('Updating book: ${book.title} (ID: ${book.id})');
      }
      return await db.update(
        'books',
        book.toMap(),
        where: 'id = ?',
        whereArgs: [book.id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating book: $e');
      }
      rethrow;
    }
  }

  // Delete a book
  Future<int> deleteBook(int id) async {
    try {
      final Database db = await database;
      if (kDebugMode) {
        print('Deleting book with ID: $id');
      }
      return await db.delete(
        'books',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting book: $e');
      }
      rethrow;
    }
  }

  // Helper method to check if a table exists
}

// Service class for book operations
class BookService {
  final BookDatabaseHelper _dbHelper = BookDatabaseHelper();

  // Add a new book
  Future<bool> addBook(Book book) async {
    try {
      if (kDebugMode) {
        print(
            'BookService: Adding book "${book.title}" for user ${book.userId}');
      }
      await _dbHelper.insertBook(book);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding book: $e');
      }
      return false;
    }
  }

  // Get all books for a user
  Future<List<Book>> getAllBooks(int userId) async {
    try {
      if (kDebugMode) {
        print('BookService: Getting all books for user $userId');
      }
      return await _dbHelper.getBooksForUser(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting all books: $e');
      }
      return [];
    }
  }

  // Get a book by id
  Future<Book?> getBookById(int id) async {
    try {
      return await _dbHelper.getBookById(id);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting book by id: $e');
      }
      return null;
    }
  }

  // Get books by author
  Future<List<Book>> getBooksByAuthor(String author, int userId) async {
    try {
      return await _dbHelper.getBooksByAuthor(author, userId);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting books by author: $e');
      }
      return [];
    }
  }

  // Get books by genre
  Future<List<Book>> getBooksByGenre(String genre, int userId) async {
    try {
      return await _dbHelper.getBooksByGenre(genre, userId);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting books by genre: $e');
      }
      return [];
    }
  }

  // Get currently reading books
  Future<List<Book>> getCurrentlyReadingBooks(int userId) async {
    try {
      if (kDebugMode) {
        print('BookService: Getting currently reading books for user $userId');
      }
      return await _dbHelper.getCurrentlyReadingBooks(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting currently reading books: $e');
      }
      return [];
    }
  }

  // Update a book
  Future<bool> updateBook(Book book) async {
    try {
      await _dbHelper.updateBook(book);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating book: $e');
      }
      return false;
    }
  }

  // Delete a book
  Future<bool> deleteBook(int id) async {
    try {
      await _dbHelper.deleteBook(id);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting book: $e');
      }
      return false;
    }
  }
}
