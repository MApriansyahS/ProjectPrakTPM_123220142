import '../model/journal_entry.dart';
import '../network/db_helper.dart';

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
