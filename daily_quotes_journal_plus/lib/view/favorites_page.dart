import 'package:flutter/material.dart';
import '../model/quote.dart';
import '../presenter/favorites_presenter.dart';

// Kelas FavoritesPage adalah tampilan (halaman) yang menampilkan daftar kutipan favorit pengguna.
// Setiap kutipan favorit ditampilkan dalam bentuk kartu (Card) yang berisi teks kutipan dan nama penulis.
//
// Penjelasan bagian utama:
// - Daftar kutipan favorit diambil dari database lokal melalui FavoritesPresenter.
// - Jika daftar masih dimuat (loading), akan muncul indikator loading (lingkaran berputar).
// - Jika belum ada kutipan favorit, akan muncul pesan "No favorite quotes yet".
// - Setiap item memiliki tombol hapus (ikon tempat sampah merah) untuk menghapus kutipan dari daftar favorit.
// - Setelah menghapus, daftar akan diperbarui dan muncul notifikasi singkat di bawah layar.

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesPresenter _presenter = FavoritesPresenter();
  List<Quote> _favorites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favs = await _presenter.loadFavorites();
    setState(() {
      _favorites = favs;
      _loading = false;
    });
  }

  Future<void> _removeFavorite(String text) async {
    await _presenter.removeFavorite(text);
    await _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Favorite removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Quotes'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? const Center(child: Text('No favorite quotes yet'))
              : ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final quote = _favorites[index];
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(
                          '"${quote.text}"',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        subtitle: Text('- ${quote.author}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _removeFavorite(quote.text),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
