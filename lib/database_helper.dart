import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'notes.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

  String notesTable = 'notes_table';
  String colId = 'id'; 
  String colNamaPerangkat = 'namaPerangkat';
  String colPenggunaan = 'penggunaan'; 
  String colDurasi = 'durasi'; 
  String colDate = 'date';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    await deleteDatabase(path);

    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $notesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colNamaPerangkat TEXT, $colPenggunaan INTEGER, $colDurasi INTEGER, $colDate TEXT)');
  }

  Future<List<Notes>> getNotes() async {
    Database db = await this.database;
    var result = await db.query(notesTable, orderBy: '$colDate ASC');
    List<Notes> notesList = result.isNotEmpty
        ? result.map((note) => Notes.fromMapObject(note)).toList()
        : [];
    return notesList;
  }


  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNotesMapList() async {
    Database db = await this.database;
    var result = await db.query(notesTable, orderBy: '$colDate ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<void> insertNotes(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      notesTable, // Table name
      {
        'namaPerangkat' : data['name'], //
        'penggunaan': data['penusageggunaan'], 
        'durasi': data['duration'],
        'date': data['date'],
      }, 
      conflictAlgorithm: ConflictAlgorithm.replace,// Handle conflicts
    );
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNotes(Notes notes) async {
    var db = await this.database;
    var result = await db.update(notesTable, notes.toMap(), where: '$colId = ?', whereArgs: [notes.id]);
    return result; 
  }

  // Get number of Note objects in database
  Future<int> getNotesCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $notesTable');
    int result = Sqflite.firstIntValue(x)!;
    return result;
  }

}
