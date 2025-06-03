// Kelas JournalEntry digunakan untuk merepresentasikan satu catatan harian (journal entry).
// Setiap catatan memiliki beberapa atribut, yaitu:
// - id: Nomor unik untuk membedakan setiap catatan (opsional, bisa kosong).
// - title: Judul catatan (wajib diisi).
// - content: Isi atau teks utama dari catatan (wajib diisi).
// - imagePath: Lokasi gambar yang terkait dengan catatan (opsional).
// - date: Tanggal saat catatan dibuat (wajib diisi).

class JournalEntry {
  int? id; // ID unik, bisa null jika belum disimpan ke database
  String title; // Judul catatan
  String content; // Isi catatan
  String? imagePath; // Path gambar, opsional
  String date; // Tanggal catatan

  // Konstruktor untuk membuat objek JournalEntry baru.
  JournalEntry({
    this.id,
    required this.title,
    required this.content,
    this.imagePath,
    required this.date,
  });

  // Fungsi untuk mengubah objek JournalEntry menjadi Map (struktur data seperti kamus).
  // Map ini biasanya digunakan untuk menyimpan data ke database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'date': date,
    };
  }

  // Fungsi factory untuk membuat objek JournalEntry dari Map.
  // Biasanya digunakan saat mengambil data dari database.
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imagePath: map['imagePath'],
      date: map['date'],
    );
  }
}
