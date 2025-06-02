import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/quote.dart';

class ApiService {
  static const String _baseUrlRandom = 'https://api.quotable.io/random';

  // Method untuk mendapatkan quote berdasarkan kategori (tag)
  Future<Quote> fetchQuoteByCategory(String tag) async {
    final url = 'https://api.quotable.io/random?tags=$tag';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Quote.fromJson(jsonData);
    } else {
      throw Exception('Failed to load quote');
    }
  }
  
  // Method untuk mendapatkan quote acak tanpa kategori
  Future<Quote> fetchRandomQuote() async {
    final response = await http.get(Uri.parse(_baseUrlRandom));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Quote.fromJson(jsonData);
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
