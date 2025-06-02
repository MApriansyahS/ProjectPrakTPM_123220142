import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/quote.dart';
import '../model/journal_entry.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_data.db');

    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        author TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE journal(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        imagePath TEXT,
        date TEXT NOT NULL
      )
    ''');
  }

  // Favorites CRUD
  Future<int> insertFavorite(Quote quote) async {
    final db = await database;
    return await db.insert('favorites', {
      'text': quote.text,
      'author': quote.author,
    });
  }

  Future<List<Quote>> getFavorites() async {
    final db = await database;
    final result = await db.query('favorites');
    return result
        .map((json) => Quote(text: json['text'] as String, author: json['author'] as String))
        .toList();
  }

  Future<int> deleteFavorite(String text) async {
    final db = await database;
    return await db.delete('favorites', where: 'text = ?', whereArgs: [text]);
  }

  // Journal CRUD
  Future<int> insertJournalEntry(JournalEntry entry) async {
    final db = await database;
    return await db.insert('journal', entry.toMap());
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    final db = await database;
    final result = await db.query('journal', orderBy: 'date DESC');
    return result.map((json) => JournalEntry.fromMap(json)).toList();
  }

  Future<int> updateJournalEntry(JournalEntry entry) async {
    final db = await database;
    return await db.update('journal', entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<int> deleteJournalEntry(int id) async {
    final db = await database;
    return await db.delete('journal', where: 'id = ?', whereArgs: [id]);
  }
}
