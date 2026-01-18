// Import library material untuk menggunakan widget Material Design
import 'package:flutter/material.dart';
// Import model Candi
import 'package:wisata_candi/models/candi.dart';
// Import database helper
import 'package:wisata_candi/helpers/database_helper.dart';
// Import widget ItemCard
import 'package:wisata_candi/widgets/item_card.dart';
// Import untuk mengecek platform
import 'package:flutter/foundation.dart' show kIsWeb;
// Import data static sebagai fallback
import 'package:wisata_candi/data/candi_data.dart';

// Kelas FavoriteScreen yang merupakan StatefulWidget karena memiliki state yang berubah
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // List untuk menyimpan data candi favorit
  List<Candi> _favoriteCandi = [];
  // Database helper instance
  final DatabaseHelper _dbHelper = DatabaseHelper();
  // Flag untuk menandai sedang loading
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load data favorit saat widget diinisialisasi
    _loadFavoriteData();
  }

  // Fungsi untuk load data candi favorit dari database
  Future<void> _loadFavoriteData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Untuk web, filter dari data static
      if (kIsWeb) {
        setState(() {
          _favoriteCandi = candiList
              .where((candi) => candi.isFavorite)
              .toList();
          _isLoading = false;
        });
        return;
      }

      // Untuk mobile/desktop, ambil dari database
      final favoriteList = await _dbHelper.getFavoriteCandi();

      setState(() {
        _favoriteCandi = favoriteList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading favorite data: $e');
      // Fallback ke data static yang di-filter
      setState(() {
        _favoriteCandi = candiList.where((candi) => candi.isFavorite).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul Favorit
      appBar: AppBar(
        title: Text('Favorit'),
        // Tombol refresh untuk reload data
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadFavoriteData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      // Body dengan kondisi loading, empty, atau list
      body: _isLoading
          // Tampilkan loading indicator saat sedang load data
          ? Center(child: CircularProgressIndicator())
          // Jika tidak loading, cek apakah list kosong
          : _favoriteCandi.isEmpty
          // Tampilkan pesan jika tidak ada favorit
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon hati kosong
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  // Pesan tidak ada favorit
                  Text(
                    'Belum ada candi favorit',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  // Instruksi untuk menambah favorit
                  Text(
                    'Tap ikon hati pada detail candi untuk menambahkan',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          // Tampilkan grid jika ada data favorit
          : GridView.builder(
              // Konfigurasi grid dengan 2 kolom
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              // Padding di sekitar grid
              padding: EdgeInsets.all(8),
              // Jumlah item sesuai dengan jumlah favorit
              itemCount: _favoriteCandi.length,
              // Builder untuk setiap item
              itemBuilder: (context, index) {
                return ItemCard(candi: _favoriteCandi[index]);
              },
            ),
    );
  }
}
