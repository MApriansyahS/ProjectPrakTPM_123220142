// Kelas Quote digunakan untuk merepresentasikan sebuah kutipan (quote).
// Setiap kutipan memiliki dua atribut utama:
// - text: Isi atau kalimat kutipan (wajib diisi).
// - author: Nama penulis atau sumber kutipan (wajib diisi).

class Quote {
  final String text;    // Isi kutipan
  final String author;  // Penulis kutipan

  // Konstruktor untuk membuat objek Quote baru.
  Quote({required this.text, required this.author});

  // Fungsi factory untuk membuat objek Quote dari data JSON (Map).
  // Jika data tidak lengkap, akan diisi nilai default.
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['content'] ?? 'No quote',    // Jika tidak ada, isi dengan 'No quote'
      author: json['author'] ?? 'Unknown',    // Jika tidak ada, isi dengan 'Unknown'
    );
  }
}
