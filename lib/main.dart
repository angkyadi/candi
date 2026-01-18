import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // TAMBAHKAN
import 'package:wisata_candi/helpers/database_helper.dart'; // TAMBAHKAN
import 'package:wisata_candi/data/candi_data.dart'; // TAMBAHKAN
import 'package:wisata_candi/screens/favorite_screen.dart';
import 'package:wisata_candi/screens/home_screen.dart';
import 'package:wisata_candi/screens/profile_screen.dart';
import 'package:wisata_candi/screens/search_screen.dart';
import 'package:wisata_candi/screens/signup_screen.dart';
import 'package:wisata_candi/screens/signin_screen.dart';
// import 'package:wisata_candi/screens/detail_screen.dart';
// import 'package:wisata_candi/screens/profile_screen.dart';
// import 'package:wisata_candi/screens/search_screen.dart';
// import 'package:wisata_candi/screens/signin_screen.dart';
// import 'data/candi_data.dart';

void main() async {
  // ✅ TAMBAHKAN async
  WidgetsFlutterBinding.ensureInitialized(); // ✅ TAMBAHKAN INI

  // ✅ TAMBAHKAN - Inisialisasi database untuk non-web platform
  if (!kIsWeb) {
    try {
      await _initializeDatabase();
    } catch (e) {
      print('❌ Error initializing database: $e');
    }
  }

  runApp(const MainApp());
}

Future<void> _initializeDatabase() async {
  try {
    final dbHelper = DatabaseHelper();

    print('Checking database status...');

    // Check apakah database sudah memiliki data
    final isEmpty = await dbHelper.isDatabaseEmpty();

    if (isEmpty) {
      print('Database empty, migrating data...');

      // Migrasi data dari static list ke database
      await dbHelper.insertCandiList(candiList);

      print('Data candi berhasil dimigrasikan ke database');
    } else {
      print('Database sudah memiliki data');
    }
  } catch (e) {
    print('Database initialization error: $e');
    rethrow;
  }
}

/// The main application widget.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure candiList is not empty before accessing its first element
    //final candi = candiList.isNotEmpty ? candiList[0] : null;

    return MaterialApp(
      title: "Wisata Candi",
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.deepPurple),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ).copyWith(primary: Colors.deepPurple, surface: Colors.deepPurple[50]),
      ),
      // Definisi named routes untuk navigasi
      routes: {
        '/': (context) => MainScreen(),
        '/signup': (context) => SignUpScreen(),
        '/signin': (context) => SigninScreen(),
      },
      // Initial route - halaman pertama yang dibuka
      initialRoute: '/',
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // TODO 1 : Deklarasikan variabel
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    SearchScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO 2 : Buat propeti Body
      body: _children[_currentIndex],
      // TODO 3 : Buat properti BottomNavigationBar
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.deepPurple[50]),
        // TODO 4 : Buat data dan child dari theme
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.deepPurple),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.deepPurple),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.deepPurple),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.deepPurple),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.deepPurple[100],
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
