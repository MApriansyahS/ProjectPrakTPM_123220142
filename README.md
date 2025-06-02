# Daily Quotes & Journal Plus

Aplikasi Flutter untuk mendapatkan kutipan inspiratif harian, menyimpan kutipan favorit, dan menulis jurnal harian lengkap dengan gambar.

## Fitur

- **Quotes**: Dapatkan kutipan acak berdasarkan kategori, simpan ke favorit.
- **Favorites**: Lihat dan kelola daftar kutipan favorit Anda.
- **Journal**: Tulis, edit, dan hapus entri jurnal harian, bisa menambahkan gambar.
- **Settings**: Ubah tema (dark/light), atur ukuran font, dan logout.
- **Authentication**: Login dan registrasi sederhana berbasis `SharedPreferences`.

## Struktur Folder

```
lib/
  main.dart
  model/
    journal_entry.dart
    quote.dart
  network/
    api_service.dart
    auth_helper.dart
    db_helper.dart
    preferences_helper.dart
  presenter/
    favorites_presenter.dart
    journal_presenter.dart
    quote_presenter.dart
  view/
    auth_page.dart
    favorites_page.dart
    journal_page.dart
    quotes_page.dart
    settings_page.dart
assets/
  icon/
```

## Instalasi

1. Clone repositori ini.
2. Jalankan `flutter pub get` untuk mengunduh dependencies.
3. Jalankan aplikasi dengan `flutter run`.

## Konfigurasi

- Pastikan dependencies berikut ada di `pubspec.yaml`:
  - `sqflite`
  - `shared_preferences`
  - `image_picker`
  - `http`
  - `intl`
- Tambahkan permission untuk akses kamera dan storage jika build di Android/iOS.

## Cara Penggunaan

- **Quotes**: Pilih kategori, tekan "New Quote" untuk mendapatkan kutipan baru, tekan "Add to Favorites" untuk menyimpan.
- **Favorites**: Lihat daftar kutipan favorit, hapus jika tidak diinginkan.
- **Journal**: Tambah entri baru, edit, hapus, dan tambahkan gambar dari kamera/galeri.
- **Settings**: Ubah tema, ukuran font, dan logout.

## Catatan

- Data user, jurnal, dan favorit disimpan secara lokal (offline).
- Kutipan diambil dari API [Quotable](https://api.quotable.io/).

## Lisensi

MIT License

---

**File utama:**  
- [lib/main.dart](lib/main.dart)  
- [lib/view/quotes_page.dart](lib/view/quotes_page.dart)  
- [lib/view/journal_page.dart](lib/view/journal_page.dart)  
- [lib/view/favorites_page.dart](lib/view/favorites_page.dart)  
- [lib/view/settings_page.dart](lib/view/settings_page.dart)  
- [lib/view/auth_page.dart](lib/view/auth_page.dart)
