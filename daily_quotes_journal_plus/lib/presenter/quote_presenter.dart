import 'package:daily_quotes_journal_plus/model/quote.dart';
import 'package:daily_quotes_journal_plus/network/api_service.dart';

// Kelas QuotePresenter berfungsi sebagai penghubung antara tampilan aplikasi (UI) dan layanan pengambilan kutipan dari internet.
// Kelas ini mengelola proses mengambil kutipan acak atau berdasarkan kategori dari API.
//
// Penjelasan fungsi-fungsi utama:
// - getQuote(): Mengambil satu kutipan acak dari internet.
// - getQuoteByCategory(String tag): Mengambil satu kutipan acak berdasarkan kategori tertentu.


class QuotePresenter {
  final ApiService _apiService = ApiService();

  Future<Quote> getQuote() async {
    return await _apiService.fetchRandomQuote();
  }

  Future<Quote> getQuoteByCategory(String tag) async {
    return await _apiService.fetchQuoteByCategory(tag);
  }
}
