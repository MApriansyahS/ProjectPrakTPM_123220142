import 'package:flutter/material.dart';
import '../model/quote.dart';
import '../presenter/quote_presenter.dart';
import '../presenter/favorites_presenter.dart';

// Kelas QuotesPage adalah tampilan utama untuk fitur kutipan (quotes) di aplikasi.
// Pengguna dapat memilih kategori kutipan, melihat kutipan inspiratif, dan menambahkannya ke daftar favorit.
//
// Penjelasan bagian utama:
// - Dropdown kategori: Pengguna dapat memilih kategori kutipan (misal: Business, Life, Success, dll).
// - Saat kategori dipilih, aplikasi akan mengambil kutipan baru dari internet sesuai kategori tersebut.
// - Jika data masih dimuat, akan muncul indikator loading (lingkaran berputar).
// - Jika terjadi error saat mengambil kutipan, akan muncul pesan error berwarna merah.
// - Jika kutipan berhasil diambil, akan ditampilkan teks kutipan dan nama penulisnya dengan tampilan menarik.
// - Tombol "Add to Favorites": Untuk menyimpan kutipan ke daftar favorit pengguna.
// - Tombol "New Quote": Untuk mengambil kutipan baru dari kategori yang sama.

class QuotesPage extends StatefulWidget {
  final double fontSize;
  const QuotesPage({Key? key, this.fontSize = 16.0}) : super(key: key);

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  final QuotePresenter _presenter = QuotePresenter();
  final FavoritesPresenter _favoritesPresenter = FavoritesPresenter();

  Quote? _quote;
  bool _loading = false;
  String? _error;

  final List<String> categories = [
    'Business', 'Change', 'Competition', 'Famous Quotes', 'Friendship', 
    'Future', 'Happiness', 'Life', 'Motivational', 'Success', 'Technology', 
    'Wisdom'
  ];

  String selectedCategory = 'Business'; // Default selected category

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  Future<void> _fetchQuote() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final tag = categoryToTag[selectedCategory] ?? 'business'; // Default to 'business'
      final quote = await _presenter.getQuoteByCategory(tag);
      setState(() {
        _quote = quote;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _onCategoryChanged(String? newCategory) {
    if (newCategory != null && newCategory != selectedCategory) {
      setState(() {
        selectedCategory = newCategory;
      });
      _fetchQuote();
    }
  }

  final Map<String, String> categoryToTag = {
    'Business': 'business',
    'Change': 'change',
    'Competition': 'competition',
    'Famous Quotes': 'famous-quotes',
    'Friendship': 'friendship',
    'Future': 'future',
    'Happiness': 'happiness',
    'Life': 'life',
    'Motivational': 'motivational',
    'Success': 'success',
    'Technology': 'technology',
    'Wisdom': 'wisdom',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: _onCategoryChanged,
              isExpanded: true,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: _loading
                    ? const CircularProgressIndicator()
                    : _error != null
                        ? Text(
                            'Error: $_error',
                            style: TextStyle(color: Colors.red, fontSize: widget.fontSize),
                          )
                        : _quote == null
                            ? Text('No quote available', style: TextStyle(fontSize: widget.fontSize))
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '"${_quote!.text}"',
                                    style: TextStyle(
                                      fontSize: widget.fontSize + 8,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    '- ${_quote!.author}',
                                    style: TextStyle(
                                      fontSize: widget.fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await _favoritesPresenter.addFavorite(_quote!);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Added to favorites')),
                                      );
                                    },
                                    icon: const Icon(Icons.favorite),
                                    label: const Text('Add to Favorites'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _fetchQuote,
              icon: const Icon(Icons.refresh),
              label: const Text('New Quote'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
