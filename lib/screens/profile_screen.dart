// Import library material untuk menggunakan widget Material Design
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// Import widget custom ProfileInfoItem dari folder widgets
import 'package:wisata_candi/widgets/profile_info_item.dart';
// Import image_picker untuk mengambil gambar dari kamera/galeri
import 'package:image_picker/image_picker.dart';
// Import shared_preferences untuk menyimpan path gambar profil
import 'package:shared_preferences/shared_preferences.dart';
// Import database helper untuk mengambil jumlah favorit
import 'package:wisata_candi/helpers/database_helper.dart';
// Import data static untuk fallback web
import 'package:wisata_candi/data/candi_data.dart';

// Kelas ProfileScreen yang merupakan StatefulWidget karena memiliki state yang berubah
class ProfileScreen extends StatefulWidget {
  // Constructor dengan optional parameter key
  const ProfileScreen({super.key});

  @override
  // Method untuk membuat state dari widget ini
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// State class untuk ProfileScreen yang mengelola state widget
class _ProfileScreenState extends State<ProfileScreen> {
  // TODO: 1. Deklarasikan variabel untuk menyimpan data profil
  // Variabel untuk menandai apakah user sudah sign in (default: false)
  bool isSignedIn = false;
  // Variabel untuk menyimpan nama lengkap user (default: string kosong)
  String fullName = "";
  // Variabel untuk menyimpan username (default: string kosong)
  String userName = "";
  // Variabel untuk menyimpan jumlah candi favorit (default: 0)
  int favoriteCandiCount = 0;

  // Variabel untuk menyimpan path gambar profil
  String _imageFile = '';
  // Instance ImagePicker untuk mengambil gambar
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load data profil dari SharedPreferences saat widget diinisialisasi
    _loadProfileData();
  }

  // Fungsi untuk load data profil dari SharedPreferences dan database
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load jumlah favorit dari database
    int favoriteCount = 0;
    try {
      if (kIsWeb) {
        // Untuk web, hitung dari data static
        favoriteCount = candiList.where((candi) => candi.isFavorite).length;
      } else {
        // Untuk mobile/desktop, ambil dari database
        final dbHelper = DatabaseHelper();
        final favoriteList = await dbHelper.getFavoriteCandi();
        favoriteCount = favoriteList.length;
      }
    } catch (e) {
      print('Error loading favorite count: $e');
    }

    setState(() {
      // Ambil path gambar dari SharedPreferences dengan key 'profile_image_path'
      _imageFile = prefs.getString('profile_image_path') ?? '';
      // Ambil status isSignedIn dari SharedPreferences
      isSignedIn = prefs.getBool('isSignedIn') ?? false;
      // Ambil fullName dari SharedPreferences
      fullName = prefs.getString('fullName') ?? '';
      // Ambil userName dari SharedPreferences
      userName = prefs.getString('username') ?? '';
      // Set jumlah favorit dari database
      favoriteCandiCount = favoriteCount;
    });
  }

  // Fungsi untuk menyimpan path gambar profil ke SharedPreferences
  Future<void> _saveProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', path);
  }

  // Fungsi untuk mengambil gambar dari kamera atau galeri
  Future<void> _getImage(ImageSource source) async {
    // Mengambil gambar dari sumber yang ditentukan (kamera/galeri)
    final pickedFile = await picker.pickImage(source: source);
    // Jika user memilih gambar (tidak cancel)
    if (pickedFile != null) {
      setState(() {
        // Simpan path gambar ke variabel _imageFile
        _imageFile = pickedFile.path;
      });
      // Simpan path gambar ke SharedPreferences
      await _saveProfileImage(pickedFile.path);
    }
  }

  // Fungsi untuk menampilkan modal bottom sheet pilihan sumber gambar
  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          // Set MainAxisSize.min agar tinggi bottom sheet minimal
          mainAxisSize: MainAxisSize.min,
          children: [
            // ListTile pertama untuk judul
            ListTile(
              title: Text(
                'Image Source',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // ListTile kedua untuk opsi Gallery
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                // Tutup bottom sheet
                Navigator.of(context).pop();
                // Ambil gambar dari galeri
                _getImage(ImageSource.gallery);
              },
            ),
            // ListTile ketiga untuk opsi Camera
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Camera'),
              onTap: () {
                // Tutup bottom sheet
                Navigator.of(context).pop();
                // Ambil gambar dari kamera
                _getImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  // TODO: 5. Implementasi fungsi Sign In
  // Fungsi untuk menangani proses sign in
  void signIn() {
    // setState untuk memperbarui UI
    setState(() {
      // Toggle nilai isSignedIn (mengubah false menjadi true atau sebaliknya)
      isSignedIn = !isSignedIn;
    });
  }

  // TODO: 6. Implementasi fungsi Sign Out
  // Fungsi untuk menangani proses sign out
  void signOut() async {
    final prefs = await SharedPreferences.getInstance();
    // Hapus status isSignedIn dari SharedPreferences
    await prefs.setBool('isSignedIn', false);
    // setState untuk memperbarui UI
    setState(() {
      // Set isSignedIn menjadi false
      isSignedIn = false;
    });
  }

  @override
  // Method build untuk membangun tampilan widget
  Widget build(BuildContext context) {
    // Scaffold adalah struktur dasar halaman
    return Scaffold(
      // Body berisi konten utama halaman
      body: Stack(
        // Stack untuk menumpuk widget (layer)
        children: [
          // Container sebagai background header berwarna ungu
          Container(
            // Tinggi container 200 pixel
            height: 200,
            // Lebar container memenuhi layar
            width: double.infinity,
            // Warna background ungu tua
            color: Colors.deepPurple,
          ),
          // Padding memberikan jarak horizontal 16 pixel
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            // Column untuk menyusun widget secara vertikal
            child: Column(
              children: [
                // TODO 2 : Buat bagian ProfileHeader yang berisi gambar profil
                // Align untuk menempatkan widget di posisi tertentu
                Align(
                  // Menempatkan widget di tengah atas
                  alignment: Alignment.topCenter,
                  // Padding dengan jarak dari atas 150 pixel (200-50)
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200 - 50),
                    // Stack untuk menumpuk avatar dan icon kamera
                    child: Stack(
                      // Alignment icon di kanan bawah
                      alignment: Alignment.bottomRight,
                      children: [
                        // Container sebagai border untuk avatar
                        Container(
                          // Dekorasi untuk border avatar
                          decoration: BoxDecoration(
                            // Border dengan warna ungu dan lebar 2 pixel
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 2,
                            ),
                            // Bentuk border lingkaran
                            shape: BoxShape.circle,
                          ),
                          // CircleAvatar untuk menampilkan foto profil
                          child: CircleAvatar(
                            // Radius (jari-jari) avatar 50 pixel
                            radius: 50,
                            // Jika ada gambar profil yang dipilih, tampilkan dari file
                            // Jika tidak, tampilkan gambar placeholder dari asset
                            backgroundImage: _imageFile.isNotEmpty
                                ? FileImage(File(_imageFile))
                                : AssetImage('images/placeholder_image.png')
                                      as ImageProvider,
                          ),
                        ),
                        // Kondisi: tampilkan icon kamera hanya jika user sudah sign in
                        if (isSignedIn)
                          // IconButton untuk mengubah foto profil
                          IconButton(
                            // Fungsi ketika tombol ditekan - menampilkan picker
                            onPressed: _showPicker,
                            // Icon kamera
                            icon: Icon(
                              Icons.camera_alt,
                              // Warna icon ungu muda
                              color: Colors.deepPurple[50],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // TODO 3 : Buat bagian ProfileInfo yang berisi informasi profil
                // SizedBox untuk memberikan jarak vertikal 20 pixel
                SizedBox(height: 20),
                // Divider (garis pemisah) dengan warna ungu muda
                Divider(color: Colors.deepPurple[100]),
                // SizedBox untuk memberikan jarak vertikal 4 pixel
                SizedBox(height: 4),
                // ProfileInfoItem untuk menampilkan informasi username
                ProfileInfoItem(
                  // Icon gembok
                  icon: Icons.lock,
                  // Label "Pengguna"
                  label: 'Pengguna',
                  // Nilai dari variabel userName
                  value: userName,
                  // Warna icon kuning
                  iconColor: Colors.amber,
                ),
                // SizedBox untuk memberikan jarak vertikal 4 pixel
                SizedBox(height: 4),
                // Divider (garis pemisah) dengan warna ungu muda
                Divider(color: Colors.deepPurple[100]),
                // SizedBox untuk memberikan jarak vertikal 4 pixel
                SizedBox(height: 4),
                // ProfileInfoItem untuk menampilkan informasi nama lengkap
                ProfileInfoItem(
                  // Icon person
                  icon: Icons.person,
                  // Label "Nama"
                  label: 'Nama',
                  // Nilai dari variabel fullName
                  value: fullName,
                  // Tampilkan icon edit hanya jika user sudah sign in
                  showEditIcon: isSignedIn,
                  // Fungsi ketika icon edit ditekan
                  onEditPressed: () {
                    // Print pesan debug ke console
                    debugPrint('Icon edit ditekan');
                  },
                  // Warna icon biru
                  iconColor: Colors.blue,
                ),
                // SizedBox untuk memberikan jarak vertikal 4 pixel
                SizedBox(height: 4),
                // Divider (garis pemisah) dengan warna ungu muda
                Divider(color: Colors.deepPurple[100]),
                // SizedBox untuk memberikan jarak vertikal 4 pixel
                SizedBox(height: 4),
                // ProfileInfoItem untuk menampilkan informasi jumlah favorit
                ProfileInfoItem(
                  // Icon favorite (hati)
                  icon: Icons.favorite,
                  // Label "Favorit"
                  label: 'Favorit',
                  // Tampilkan jumlah favorit jika > 0, jika tidak tampilkan string kosong
                  value: favoriteCandiCount > 0 ? '$favoriteCandiCount' : '',
                  // Warna icon merah
                  iconColor: Colors.red,
                ),
                // TODO 4 : Buat bagian ProfileActions yang berisi TextButton Sign In dan Sign Out
                // SizedBox untuk memberikan jarak vertikal 4 pixel
                SizedBox(height: 4),
                // Divider (garis pemisah) dengan warna ungu muda
                Divider(color: Colors.deepPurple[100]),
                // SizedBox untuk memberikan jarak vertikal 20 pixel
                SizedBox(height: 20),
                // Conditional rendering: tampilkan tombol sesuai status sign in
                isSignedIn
                    // Jika user sudah sign in, tampilkan tombol Sign Out
                    ? TextButton(onPressed: signOut, child: Text('Sign Out'))
                    // Jika user belum sign in, tampilkan tombol Sign Up untuk navigasi ke halaman registrasi
                    : TextButton(
                        onPressed: () {
                          // Navigasi ke halaman Sign Up
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text('Sign Up'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
