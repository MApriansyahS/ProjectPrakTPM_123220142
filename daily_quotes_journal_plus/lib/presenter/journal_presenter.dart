import '../model/journal_entry.dart';
import '../network/db_helper.dart';

// Kelas JournalPresenter berfungsi sebagai penghubung antara tampilan aplikasi (UI) dan database catatan harian.
// Kelas ini mengelola proses mengambil, menambah, memperbarui, dan menghapus catatan harian pengguna.
//
// Penjelasan fungsi-fungsi utama:
// - loadJournalEntries(): Mengambil semua catatan harian yang sudah disimpan di database.
// - addJournalEntry(JournalEntry entry): Menyimpan catatan harian baru ke database.
// - updateJournalEntry(JournalEntry entry): Memperbarui catatan harian yang sudah ada di database.
// - deleteJournalEntry(int id): Menghapus catatan harian berdasarkan ID.

class JournalPresenter {
  final DBHelper _dbHelper = DBHelper();

  Future<List<JournalEntry>> loadJournalEntries() async {
    return await _dbHelper.getJournalEntries();
  }

  Future<void> addJournalEntry(JournalEntry entry) async {
    await _dbHelper.insertJournalEntry(entry);
  }

  Future<void> updateJournalEntry(JournalEntry entry) async {
    await _dbHelper.updateJournalEntry(entry);
  }

  Future<void> deleteJournalEntry(int id) async {
    await _dbHelper.deleteJournalEntry(id);
  }
}
