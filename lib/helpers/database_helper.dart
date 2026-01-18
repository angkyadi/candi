import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/candi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:path_provider/path_provider.dart';

// Class helper untuk mengelola database SQLite
class DatabaseHelper {
  // Singleton pattern - memastikan hanya ada satu instance DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Factory constructor untuk mengembalikan instance yang sama
  factory DatabaseHelper() {
    return _instance;
  }

  // Private constructor
  DatabaseHelper._internal();

  // Getter untuk mendapatkan database
  Future<Database> get database async {
    // Jika database sudah ada, return database tersebut
    if (_database != null) return _database!;

    // Jika belum ada, inisialisasi database
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDatabase() async {
    // Untuk Web platform, gunakan sqflite_common_ffi_web
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;

      // Membuka database untuk web
      return await openDatabase(
        'wisata_candi.db',
        version: 1,
        onCreate: _onCreate,
      );
    }

    // Untuk platform desktop (Windows, Linux, macOS)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Inisialisasi FFI untuk desktop
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      // Untuk desktop, gunakan path dari app documents
      final appDocumentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(appDocumentsDirectory.path, 'wisata_candi.db');

      print('📁 Database location (Desktop): $path');

      return await openDatabase(path, version: 1, onCreate: _onCreate);
    }

    // Untuk platform mobile (Android/iOS) - gunakan getDatabasesPath()
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'wisata_candi.db');

    // Print lokasi database untuk debugging
    print('📁 Database location (Mobile): $path');

    // Membuka database, jika belum ada maka akan dibuat
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Membuat tabel saat database pertama kali dibuat
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE candi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        description TEXT NOT NULL,
        built TEXT NOT NULL,
        type TEXT NOT NULL,
        imageAsset TEXT NOT NULL,
        imageUrls TEXT NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // INSERT - Menambahkan data candi ke database
  Future<int> insertCandi(Candi candi) async {
    final db = await database;
    return await db.insert('candi', candi.toMap());
  }

  // INSERT BATCH - Menambahkan banyak data candi sekaligus
  Future<void> insertCandiList(List<Candi> candiList) async {
    final db = await database;
    Batch batch = db.batch();

    for (var candi in candiList) {
      batch.insert('candi', candi.toMap());
    }

    await batch.commit(noResult: true);
  }

  // READ - Mengambil semua data candi
  Future<List<Candi>> getAllCandi() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('candi');

    return List.generate(maps.length, (i) {
      return Candi.fromMap(maps[i]);
    });
  }

  // READ - Mengambil candi berdasarkan ID
  Future<Candi?> getCandiById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'candi',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Candi.fromMap(maps[0]);
  }

  // READ - Mengambil semua candi favorit
  Future<List<Candi>> getFavoriteCandi() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'candi',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Candi.fromMap(maps[i]);
    });
  }

  // UPDATE - Mengupdate data candi
  Future<int> updateCandi(Candi candi) async {
    final db = await database;
    return await db.update(
      'candi',
      candi.toMap(),
      where: 'id = ?',
      whereArgs: [candi.id],
    );
  }

  // UPDATE - Toggle status favorite
  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'candi',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UPDATE - Mengupdate field tertentu
  Future<int> updateCandiField(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update('candi', data, where: 'id = ?', whereArgs: [id]);
  }

  // DELETE - Menghapus candi berdasarkan ID
  Future<int> deleteCandi(int id) async {
    final db = await database;
    return await db.delete('candi', where: 'id = ?', whereArgs: [id]);
  }

  // DELETE - Menghapus semua data candi
  Future<int> deleteAllCandi() async {
    final db = await database;
    return await db.delete('candi');
  }

  // SEARCH - Mencari candi berdasarkan nama atau lokasi
  Future<List<Candi>> searchCandi(String keyword) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'candi',
      where: 'name LIKE ? OR location LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );

    return List.generate(maps.length, (i) {
      return Candi.fromMap(maps[i]);
    });
  }

  // Mengecek apakah database sudah memiliki data
  Future<bool> isDatabaseEmpty() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM candi'),
    );
    return count == 0;
  }

  // Menutup database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
