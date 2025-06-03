import 'package:shared_preferences/shared_preferences.dart';

/// Kelas PreferencesHelper digunakan untuk menyimpan dan mengambil pengaturan (preferensi) aplikasi secara lokal.
/// Pengaturan yang dikelola antara lain:
/// 1. Mode gelap (dark mode): Apakah tampilan aplikasi menggunakan tema gelap atau terang.
/// 2. Ukuran font (font size): Mengatur besar kecilnya tulisan di aplikasi.
///
/// Semua data pengaturan disimpan di perangkat pengguna menggunakan SharedPreferences,
/// sehingga pengaturan tetap tersimpan meskipun aplikasi ditutup.
///
/// Penjelasan fungsi-fungsi utama:
/// - setDarkMode(bool isDark): Menyimpan pilihan mode gelap atau terang.
/// - getDarkMode(): Mengambil status mode gelap yang tersimpan.
/// - setFontSize(double size): Menyimpan ukuran font yang dipilih pengguna.
/// - getFontSize(): Mengambil ukuran font yang tersimpan, default 16.0 jika belum diatur.

class PreferencesHelper {
  static const String _keyIsDarkMode = 'is_dark_mode';
  static const String _keyFontSize = 'font_size';

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDarkMode, isDark);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsDarkMode) ?? false;
  }

  Future<void> setFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyFontSize, size);
  }

  Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyFontSize) ?? 16.0;
  }
}
