import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Table Names
  final String userTable = 'users';
  final String fixedUsageTable = 'fixed_usage';
  final String additionalUsageTable = 'additional_usage';

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'saveco_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add category column to existing tables
      await db.execute('ALTER TABLE $fixedUsageTable ADD COLUMN category TEXT');
      await db.execute('ALTER TABLE $additionalUsageTable ADD COLUMN category TEXT');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE $userTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Create fixed usage table with category column
    await db.execute('''
      CREATE TABLE $fixedUsageTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        name TEXT NOT NULL,
        usage INTEGER NOT NULL,
        duration REAL NOT NULL,
        cost REAL NOT NULL,
        date TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        category TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    // Create additional usage table with category column
    await db.execute('''
      CREATE TABLE $additionalUsageTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        name TEXT NOT NULL,
        usage INTEGER NOT NULL,
        duration REAL NOT NULL,
        cost REAL NOT NULL,
        date TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        category TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');
  }

  // User Methods
  Future<int> registerUser(String username, String email, String password) async {
    final db = await database;
    return await db.insert(userTable, {
      'username': username,
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      userTable,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Usage Methods
  Future<int> insertFixedUsage(Map<String, dynamic> usage, int userId) async {
    final db = await database;
    final dataToInsert = {
      'user_id': userId,
      'name': usage['name'],
      'usage': usage['usage'],
      'duration': usage['duration'],
      'cost': usage['cost'],
      'date': usage['date'],
      'timestamp': DateTime.now().toIso8601String(),
      'category': usage['category'] ?? 'Tetap',
    };
    return await db.insert(fixedUsageTable, dataToInsert);
  }

  Future<int> insertAdditionalUsage(Map<String, dynamic> usage, int userId) async {
    final db = await database;
    final dataToInsert = {
      'user_id': userId,
      'name': usage['name'],
      'usage': usage['usage'],
      'duration': usage['duration'],
      'cost': usage['cost'],
      'date': usage['date'],
      'timestamp': DateTime.now().toIso8601String(),
      'category': usage['category'] ?? 'Tambahan',
    };
    return await db.insert(additionalUsageTable, dataToInsert);
  }

  Future<List<Map<String, dynamic>>> getFixedUsage(int userId, String date) async {
    final db = await database;
    return await db.query(
      fixedUsageTable,
      where: 'user_id = ? AND date = ?',
      whereArgs: [userId, date],
    );
  }

  Future<List<Map<String, dynamic>>> getAdditionalUsage(int userId, String date) async {
    final db = await database;
    return await db.query(
      additionalUsageTable,
      where: 'user_id = ? AND date = ?',
      whereArgs: [userId, date],
    );
  }

  Future<List<Map<String, dynamic>>> getAllFixedUsage(int userId) async {
    final db = await database;
    return await db.query(
      fixedUsageTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllAdditionalUsage(int userId) async {
    final db = await database;
    return await db.query(
      additionalUsageTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> deleteFixedUsage(int id) async {
    final db = await database;
    await db.delete(
      fixedUsageTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAdditionalUsage(int id) async {
    final db = await database;
    await db.delete(
      additionalUsageTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateFixedUsage(Map<String, dynamic> usage) async {
    final db = await database;
    await db.update(
      fixedUsageTable,
      usage,
      where: 'id = ?',
      whereArgs: [usage['id']],
    );
  }

  Future<void> updateAdditionalUsage(Map<String, dynamic> usage) async {
    final db = await database;
    await db.update(
      additionalUsageTable,
      usage,
      where: 'id = ?',
      whereArgs: [usage['id']],
    );
  }
}