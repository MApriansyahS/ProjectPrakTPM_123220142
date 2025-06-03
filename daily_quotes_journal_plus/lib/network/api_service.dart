import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/quote.dart';

// Kelas ApiService bertugas mengambil data kutipan (quote) dari internet menggunakan API.
// API yang digunakan adalah https://api.quotable.io, yang menyediakan berbagai kutipan inspiratif.

// Penjelasan fungsi-fungsi utama:
// - fetchQuoteByCategory(String tag):
//   Mengambil satu kutipan acak dari kategori tertentu.
//   Fungsi ini mengirim permintaan ke API dengan parameter kategori (tag).
//   Jika berhasil, data kutipan diubah menjadi objek Quote dan dikembalikan.
//   Jika gagal, akan muncul pesan error.
//
// - fetchRandomQuote():
//   Mengambil satu kutipan acak tanpa memperhatikan kategori.
//   Prosesnya mirip dengan fungsi sebelumnya, hanya saja tanpa filter kategori.

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
