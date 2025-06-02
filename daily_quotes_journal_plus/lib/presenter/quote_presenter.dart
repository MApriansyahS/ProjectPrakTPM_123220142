import 'package:daily_quotes_journal_plus/model/quote.dart';
import 'package:daily_quotes_journal_plus/network/api_service.dart';

class QuotePresenter {
  final ApiService _apiService = ApiService();

  Future<Quote> getQuote() async {
    return await _apiService.fetchRandomQuote();
  }

  Future<Quote> getQuoteByCategory(String tag) async {
    return await _apiService.fetchQuoteByCategory(tag);
  }
}
