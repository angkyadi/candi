import 'package:flutter/material.dart';
import 'package:wisata_candi/data/candi_data.dart';
import 'package:wisata_candi/models/candi.dart';
import 'package:wisata_candi/widgets/item_card.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wisata_candi/helpers/database_helper.dart';
// Untuk fallback

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Candi> _candiList = []; // ✅ TAMBAHKAN
  final DatabaseHelper _dbHelper = DatabaseHelper(); // ✅ TAMBAHKAN
  bool _isLoading = true; // ✅ TAMBAHKAN

  @override
  void initState() {
    super.initState();
    _loadCandiData(); // ✅ TAMBAHKAN
  }

  Future<void> _loadCandiData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Untuk web, gunakan data static
      if (kIsWeb) {
        setState(() {
          _candiList = candiList;
          _isLoading = false;
        });
        return;
      }

      // Untuk mobile/desktop, gunakan database
      final candiListFromDb = await _dbHelper.getAllCandi();

      setState(() {
        _candiList = candiListFromDb.isNotEmpty ? candiListFromDb : candiList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data from database: $e');
      // Fallback ke data static jika terjadi error
      setState(() {
        _candiList = candiList;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Todo: 1 Buat appbar dengan judul wisata candi
      appBar: AppBar(title: Text("Wisata Candi")),
      //Todo Buat body dengan gridview
      body:
          _isLoading // ✅ TAMBAHKAN loading indicator
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              padding: EdgeInsets.all(8),
              itemCount: _candiList.length,
              itemBuilder: (context, index) {
                return ItemCard(candi: _candiList[index]);
              },
            ),
    );
  }
}
