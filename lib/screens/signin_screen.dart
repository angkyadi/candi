// Import library gestures untuk menangani gesture seperti tap
import 'package:flutter/gestures.dart';
// Import library material untuk menggunakan widget Material Design
import 'package:flutter/material.dart';
// Import SharedPreferences untuk mengambil data yang tersimpan
import 'package:shared_preferences/shared_preferences.dart';

// Kelas SigninScreen yang merupakan StatefulWidget karena memiliki state yang berubah
class SigninScreen extends StatefulWidget {
  // Constructor dengan optional parameter key
  SigninScreen({super.key});

  @override
  // Method untuk membuat state dari widget ini
  State<SigninScreen> createState() => _SigninScreenState();
}

// State class untuk SigninScreen yang mengelola state widget
class _SigninScreenState extends State<SigninScreen> {
  // TODO: 1. Deklarasikan variabel
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

  // Method untuk melakukan sign in
  void _signIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil username dan password dari input
    String inputUsername = _usernameController.text.trim();
    String inputPassword = _passwordController.text.trim();

    // Ambil data yang tersimpan dari SharedPreferences
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');

    // Validasi input tidak kosong
    if (inputUsername.isEmpty || inputPassword.isEmpty) {
      setState(() {
        _errorText = 'Username dan password tidak boleh kosong';
      });
      return;
    }

    // Validasi username dan password
    if (inputUsername == savedUsername && inputPassword == savedPassword) {
      // Sign in berhasil
      setState(() {
        _errorText = '';
        _isSignedIn = true;
      });

      // Simpan status isSignedIn ke SharedPreferences
      await prefs.setBool('isSignedIn', true);

      // Tampilkan SnackBar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign In berhasil!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigasi ke halaman utama dan hapus semua route sebelumnya
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      // Sign in gagal
      setState(() {
        _errorText = 'Username atau password salah';
      });
    }
  }

  @override
  // Method build untuk membangun tampilan widget
  Widget build(BuildContext context) {
    // Scaffold adalah struktur dasar halaman dengan AppBar dan Body
    return Scaffold(
      // TODO : 2  Pasang Appbar
      // AppBar di bagian atas halaman
      appBar: AppBar(
        // Judul AppBar
        title: const Text("Sign In"),
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
                  // TODO : 7 Pasang Button Sign In
                  // SizedBox untuk memberikan jarak vertikal 16 pixel
                  SizedBox(height: 16),
                  // ElevatedButton untuk tombol Sign In
                  ElevatedButton(
                    // Fungsi yang dipanggil saat tombol ditekan
                    onPressed: _signIn,
                    // Teks yang ditampilkan di tombol
                    child: const Text("Sign In"),
                  ),
                  // TODO : 8 Pasang Button Sign Up
                  // TextButton yang di-comment out (tidak digunakan)
                  // TextButton(
                  //   onPressed: () {},
                  //   child: const Text("Belum punya akun? Sign Up"),
                  // ),
                  // RichText untuk membuat teks dengan style berbeda
                  RichText(
                    // TextSpan adalah bagian teks dengan style tertentu
                    text: TextSpan(
                      // Teks pertama: "Belum punya akun? "
                      text: "Belum punya akun? ",
                      // Style untuk teks pertama (warna hitam)
                      style: TextStyle(color: Colors.black),
                      // Array children berisi TextSpan lainnya
                      children: [
                        // TextSpan untuk teks "Sign Up" yang bisa diklik
                        TextSpan(
                          // Teks yang ditampilkan
                          text: "Sign Up",
                          // Style dengan warna biru dan garis bawah
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          // Recognizer untuk menangani gesture tap
                          recognizer: TapGestureRecognizer()
                            // Callback saat teks di-tap
                            ..onTap = () {
                              // Navigate to Sign Up screen
                              Navigator.pushNamed(context, '/signup');
                            },
                        ),
                      ],
                    ),
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
