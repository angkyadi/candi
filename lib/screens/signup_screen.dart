// Import library gestures untuk menangani gesture seperti tap
// Import library material untuk menggunakan widget Material Design
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Kelas SignUpScreen yang merupakan StatefulWidget karena memiliki state yang berubah
class SignUpScreen extends StatefulWidget {
  // Constructor dengan optional parameter key
  SignUpScreen({super.key});

  @override
  // Method untuk membuat state dari widget ini
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// State class untuk SignUpScreen yang mengelola state widget
class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullnameController = TextEditingController();

  // Controller untuk mengelola input username
  final TextEditingController _usernameController = TextEditingController();

  // Controller untuk mengelola input password
  final TextEditingController _passwordController = TextEditingController();

  // Variabel untuk menyimpan pesan error
  String _errorText = '';

  // Variabel untuk menandai apakah user sudah sign in
  bool _isSignedIn = false;

  // Variabel untuk mengontrol visibilitas password (true = disembunyikan)
  bool _obscurePassword = true;

  // TODO 1 : buat metode _signUp
  void _signUp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Implementasi logika sign up di sini
    String fullName = _fullnameController.text
        .trim(); // Mengambil nilai dari controller dan menghapus spasi di awal/akhir
    String username = _usernameController.text
        .trim(); // Mengambil nilai dari controller dan menghapus spasi di awal/akhir
    String password = _passwordController.text
        .trim(); // Mengambil nilai dari controller dan menghapus spasi di awal/akhir

    // Contoh validasi sederhana
    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _errorText =
            'Password harus terdiri dari minimal 8 karakter, mengandung huruf  besar, huruf kecil, angka, dan simbol.';
      });
      return;
    }

    // Jika validasi berhasil, hapus pesan error
    setState(() {
      _errorText = '';
    });

    print('*** Sign Up berhasil ***');
    // print('Full Name: $fullName');
    // print('Username: $username');
    // print('Password: $password');

    prefs.setString(
      'fullName',
      fullName,
    ); // Simpan fullName ke SharedPreferences
    prefs.setString(
      'username',
      username,
    ); // Simpan username ke SharedPreferences
    prefs.setString(
      'password',
      password,
    ); // Simpan password ke SharedPreferences

    // Tampilkan SnackBar untuk notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign Up berhasil! Silakan Sign In.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // buat navigasi ke halaman Sign In setelah sign up berhasil
    Navigator.pushNamed(context, '/signin');
  }

  // TODO 2 : buat metode _dispose
  @override
  void dispose() {
    // Membersihkan controller saat widget dihapus dari widget tree
    _fullnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  // Method build untuk membangun tampilan widget
  Widget build(BuildContext context) {
    // Scaffold adalah struktur dasar halaman dengan AppBar dan Body
    return Scaffold(
      // TODO : 2  Pasang Appbar
      // AppBar di bagian atas halaman
      appBar: AppBar(
        // Icon arrow back di sebelah kiri AppBar
        leading: IconButton(
          // Icon panah kembali dengan warna putih
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          // Fungsi ketika icon ditekan untuk kembali ke halaman sebelumnya
          onPressed: () {
            // Navigator.pop untuk kembali ke halaman sebelumnya
            Navigator.pop(context);
          },
        ),
        // Judul AppBar
        title: const Text("Sign Up"),
        // Menempatkan judul di tengah
        // centerTitle: true,
        // Warna latar belakang AppBar
        backgroundColor: Colors.deepPurple,
      ),
      // TODO : 3  Pasang Body
      // Body adalah konten utama halaman
      body: Center(
        // SingleChildScrollView agar konten bisa di-scroll jika melebihi layar
        child: SingleChildScrollView(
          // Padding memberikan jarak di sekitar konten
          child: Padding(
            // Jarak 16 pixel dari semua sisi
            padding: const EdgeInsets.all(16.0),
            // Form widget untuk mengelompokkan input fields
            child: Form(
              // Column untuk menyusun widget secara vertikal
              child: Column(
                // TODO : 4 atur mainAxisAlignment dan crossAxisAlignment
                // Konten berada di tengah secara vertikal
                mainAxisAlignment: MainAxisAlignment.center,
                // Konten berada di tengah secara horizontal
                crossAxisAlignment: CrossAxisAlignment.center,
                // Array children berisi widget-widget yang akan ditampilkan
                children: [
                  // TODO : 5 Pasang Text FormField untuk Fullname
                  // TextFormField untuk input fullname
                  TextFormField(
                    // Menghubungkan controller untuk mengambil dan mengatur nilai
                    controller: _fullnameController,
                    // Dekorasi tampilan input field
                    decoration: InputDecoration(
                      // Label yang muncul di atas field
                      labelText: "Nama Lengkap",
                      // Border outline di sekitar field
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // TODO : 5 Pasang Text FormField untuk Username
                  // TextFormField untuk input username
                  TextFormField(
                    // Menghubungkan controller untuk mengambil dan mengatur nilai
                    controller: _usernameController,
                    // Dekorasi tampilan input field
                    decoration: InputDecoration(
                      // Label yang muncul di atas field
                      labelText: "Nama Pengguna",
                      // Border outline di sekitar field
                      border: OutlineInputBorder(),
                    ),
                  ),
                  // TODO : 6 Pasang Text FormField untuk Password
                  // SizedBox untuk memberikan jarak vertikal 16 pixel
                  SizedBox(height: 16),
                  // TextFormField untuk input password
                  TextFormField(
                    // Menghubungkan controller untuk mengambil dan mengatur nilai
                    controller: _passwordController,
                    // Dekorasi tampilan input field
                    decoration: InputDecoration(
                      // Label yang muncul di atas field
                      labelText: "Kata Sandi",
                      // Menampilkan pesan error jika ada
                      errorText: _errorText.isNotEmpty ? _errorText : null,
                      // Border outline di sekitar field
                      border: OutlineInputBorder(),
                      // Icon di sebelah kanan field untuk toggle visibility password
                      suffixIcon: IconButton(
                        // Fungsi yang dipanggil saat tombol ditekan
                        onPressed: () {
                          // setState untuk memperbarui UI
                          setState(() {
                            // Toggle nilai _obscurePassword (true/false)
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        // Icon yang ditampilkan berdasarkan state _obscurePassword
                        icon: Icon(
                          // Jika password tersembunyi, tampilkan icon visibility_off
                          _obscurePassword
                              ? Icons.visibility_off
                              // Jika password terlihat, tampilkan icon visibility
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    // Menyembunyikan atau menampilkan teks password
                    obscureText: _obscurePassword,
                  ),
                  // TODO : 7 Pasang Button Sign Up
                  // SizedBox untuk memberikan jarak vertikal 16 pixel
                  SizedBox(height: 16),
                  // ElevatedButton untuk tombol Sign Up
                  ElevatedButton(
                    // Fungsi yang dipanggil saat tombol ditekan (masih kosong)
                    onPressed: () {
                      _signUp();
                    },
                    // Teks yang ditampilkan di tombol
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
