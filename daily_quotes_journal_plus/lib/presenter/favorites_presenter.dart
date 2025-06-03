import '../model/quote.dart';
import '../network/db_helper.dart';

// Kelas FavoritesPresenter berfungsi sebagai penghubung antara tampilan aplikasi (UI) dan database favorit.
// Kelas ini mengelola proses mengambil, menambah, dan menghapus kutipan favorit pengguna.
//
// Penjelasan fungsi-fungsi utama:
// - loadFavorites(): Mengambil daftar kutipan favorit yang sudah disimpan di database.
// - addFavorite(Quote quote): Menyimpan kutipan baru ke daftar favorit.
// - removeFavorite(String text): Menghapus kutipan favorit berdasarkan isi kutipan.


class FavoritesPresenter {
  final DBHelper _dbHelper = DBHelper();

  Future<List<Quote>> loadFavorites() async {
    return await _dbHelper.getFavorites();
  }

  Future<void> addFavorite(Quote quote) async {
    await _dbHelper.insertFavorite(quote);
  }

  Future<void> removeFavorite(String text) async {
    await _dbHelper.deleteFavorite(text);
  }
}
