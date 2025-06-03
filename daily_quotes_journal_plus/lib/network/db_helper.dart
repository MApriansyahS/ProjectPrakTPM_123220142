import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/quote.dart';
import '../model/journal_entry.dart';

// Kelas DBHelper digunakan untuk mengelola penyimpanan data lokal aplikasi menggunakan database SQLite.
// Database ini menyimpan dua jenis data utama:
// 1. Tabel favorites: Menyimpan kutipan (quote) favorit pengguna.
// 2. Tabel journal: Menyimpan catatan harian (journal entry) pengguna.
//
// Penjelasan fungsi-fungsi utama:
// - insertFavorite(Quote quote): Menyimpan kutipan ke daftar favorit.
// - getFavorites(): Mengambil semua kutipan favorit yang sudah disimpan.
// - deleteFavorite(String text): Menghapus kutipan favorit berdasarkan isi kutipan.
//
// - insertJournalEntry(JournalEntry entry): Menyimpan catatan harian baru.
// - getJournalEntries(): Mengambil semua catatan harian yang sudah disimpan, urut dari terbaru.
// - updateJournalEntry(JournalEntry entry): Memperbarui catatan harian yang sudah ada.
// - deleteJournalEntry(int id): Menghapus catatan harian berdasarkan ID.
//
// Kode ini sangat penting agar data favorit dan catatan harian tetap tersimpan di perangkat pengguna, 
// meskipun aplikasi ditutup atau perangkat dimatikan.

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
