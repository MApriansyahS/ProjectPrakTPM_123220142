import 'dart:io';
import 'package:flutter/material.dart';
import 'network/preferences_helper.dart';
import 'view/favorites_page.dart';
import 'view/journal_page.dart';
import 'view/quotes_page.dart';
import 'view/settings_page.dart';
import 'view/auth_page.dart';
import 'network/auth_helper.dart';

// File main.dart adalah titik awal (entry point) aplikasi Flutter ini.
// Di sini diatur logika utama aplikasi, mulai dari proses login, pengaturan tema (gelap/terang), ukuran font, hingga navigasi antar halaman.
//
// Penjelasan bagian utama:
// - Mengecek status login: Jika pengguna belum login, akan diarahkan ke halaman AuthPage (login/registrasi).
// - Setelah login, pengguna dapat mengakses 4 fitur utama melalui BottomNavigationBar:
//   1. QuotesPage: Melihat dan mencari kutipan inspiratif.
//   2. FavoritesPage: Melihat daftar kutipan favorit yang sudah disimpan.
//   3. JournalPage: Membaca, menambah, dan mengelola catatan harian (jurnal). 
//   4. SettingsPage: Mengatur tema aplikasi (gelap/terang), ukuran font, dan logout.
// - Pengaturan tema dan ukuran font diambil dari PreferencesHelper dan langsung diterapkan ke seluruh aplikasi.
// - Terdapat juga menu drawer samping yang menyediakan tombol logout.

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  final AuthHelper _authHelper = AuthHelper();
  final PreferencesHelper _prefsHelper = PreferencesHelper();

  bool _isDarkMode = false;
  double _fontSize = 16.0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkLogin();
    _loadPreferences();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await _authHelper.isLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
    });
  }

  Future<void> _loadPreferences() async {
    final isDark = await _prefsHelper.getDarkMode();
    final fontSize = await _prefsHelper.getFontSize();

    setState(() {
      _isDarkMode = isDark;
      _fontSize = fontSize;
    });
  }

  void _updateDarkMode(bool value) async {
    await _prefsHelper.setDarkMode(value);
    setState(() {
      _isDarkMode = value;
    });
  }

  void _updateFontSize(double value) async {
    await _prefsHelper.setFontSize(value);
    setState(() {
      _fontSize = value;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _logout() async {
    await _authHelper.logout();
    setState(() {
      _isLoggedIn = false;
    });
  }

  // Mengatur Theme sesuai Dark Mode
  ThemeData get _themeData {
    final baseTheme = ThemeData(
      primaryColor: const Color(0xFF6CA0DC),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF6CA0DC),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6CA0DC),
        secondary: Color(0xFF8BC34A),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: const Color(0xFF37474F),
          fontWeight: FontWeight.bold,
          fontSize: _fontSize,
        ),
        bodyLarge: TextStyle(
          color: const Color(0xFF37474F),
          fontSize: _fontSize,
        ),
        bodyMedium: TextStyle(
          color: const Color(0xFF37474F),
          fontSize: _fontSize,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFF5F5F5),
        selectedItemColor: Color(0xFF8BC34A),
        unselectedItemColor: Color(0xFF37474F),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF8BC34A),
      ),
    );

    // Return dark theme copy with adjustments
    return _isDarkMode
        ? baseTheme.copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFF6CA0DC),
              secondary: const Color(0xFF8BC34A),
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: _fontSize,
              ),
              bodyLarge: TextStyle(
                color: Colors.white,
                fontSize: _fontSize,
              ),
              bodyMedium: TextStyle(
                color: Colors.white,
                fontSize: _fontSize,
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.black,
              selectedItemColor: const Color(0xFF8BC34A),
              unselectedItemColor: const Color(0xFFB0BEC5), 
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF8BC34A),
            ),
          )
        : baseTheme;
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      QuotesPage(fontSize: _fontSize),
      const FavoritesPage(),
      const JournalPage(),
      SettingsPage(
        isDarkMode: _isDarkMode,
        fontSize: _fontSize,
        onDarkModeChanged: _updateDarkMode,
        onFontSizeChanged: _updateFontSize,
        onLogout: _logout, 
      ),
    ];

    if (!_isLoggedIn) {
      return MaterialApp(
        home: AuthPage(onLoginSuccess: _onLoginSuccess),
      );
    }
    return MaterialApp(
      title: 'Daily Quotes & Journal Plus',
      theme: _themeData,
      home: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.format_quote), label: 'Quotes'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              // ...menu lain...
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


