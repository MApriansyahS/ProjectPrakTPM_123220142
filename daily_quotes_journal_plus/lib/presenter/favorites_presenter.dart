import '../model/quote.dart';
import '../network/db_helper.dart';

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
