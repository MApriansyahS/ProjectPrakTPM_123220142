import 'package:flutter/material.dart';

// Kelas SettingsPage adalah tampilan (halaman) untuk mengatur preferensi aplikasi sesuai keinginan pengguna.
// Pengguna dapat mengubah tema aplikasi (mode gelap/terang), mengatur ukuran huruf, dan melakukan logout.
//
// Penjelasan bagian utama:
// - Switch "Dark Mode": Untuk mengaktifkan atau menonaktifkan mode gelap pada aplikasi.
// - Slider "Font Size": Untuk mengatur besar kecilnya tulisan di seluruh aplikasi sesuai kebutuhan pengguna.
// - Tombol "Logout": Untuk keluar dari akun dan kembali ke halaman login.
//
// Semua perubahan pengaturan akan langsung diterapkan dan disimpan, sehingga pengalaman pengguna tetap konsisten.

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final double fontSize;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<double> onFontSizeChanged;
  final VoidCallback onLogout; 

  const SettingsPage({
    Key? key,
    required this.isDarkMode,
    required this.fontSize,
    required this.onDarkModeChanged,
    required this.onFontSizeChanged,
    required this.onLogout, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: onDarkModeChanged,
            ),
            const SizedBox(height: 24),
            Text(
              'Font Size',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Slider(
              min: 12,
              max: 30,
              divisions: 18,
              value: fontSize,
              label: fontSize.toStringAsFixed(1),
              onChanged: onFontSizeChanged,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
