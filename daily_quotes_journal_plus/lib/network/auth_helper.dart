import 'package:shared_preferences/shared_preferences.dart';

// Kelas AuthHelper digunakan untuk mengelola proses autentikasi sederhana pada aplikasi.
// Data login (username dan password) disimpan secara lokal menggunakan SharedPreferences.
// SharedPreferences adalah tempat penyimpanan data sederhana di perangkat pengguna.

// Penjelasan fungsi-fungsi utama:
// - register(username, password):
//   Menyimpan username dan password baru ke perangkat, serta menandai pengguna sebagai sudah login.
//
// - login(username, password):
//   Memeriksa apakah username dan password yang dimasukkan cocok dengan data yang tersimpan.
//   Jika cocok, pengguna dianggap berhasil login.
//
// - logout():
//   Mengubah status login menjadi false (keluar dari aplikasi).
//
// - isLoggedIn():
//   Mengecek apakah pengguna saat ini sudah login atau belum.
//
// - getCurrentUsername():
//   Mengambil username pengguna yang sedang aktif (jika ada).

class AuthHelper {
  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';
  static const String _keyIsLoggedIn = 'is_logged_in';

  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Simpan username & password
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPassword, password);
    await prefs.setBool(_keyIsLoggedIn, true);
    return true;
  }

  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString(_keyUsername);
    final savedPassword = prefs.getString(_keyPassword);
    if (username == savedUsername && password == savedPassword) {
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Tambahkan getter untuk username aktif
  Future<String?> getCurrentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }
}

