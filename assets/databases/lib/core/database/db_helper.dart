import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _alquranDb;
  static Database? _terjemahanDb;

  // Nama file harus persis sama dengan yang ada di assets/databases/
  static const String alquranFileName = 'alquran.db';
  static const String terjemahanFileName = 'terjemahan.db';

  // Fungsi buat inisialisasi dan copy database dari assets ke sistem HP
  Future<Database> getAlquranDb() async {
    if (_alquranDb != null) return _alquranDb!;
    _alquranDb = await _initDb(alquranFileName);
    return _alquranDb!;
  }

  Future<Database> getTerjemahanDb() async {
    if (_terjemahanDb != null) return _terjemahanDb!;
    _terjemahanDb = await _initDb(terjemahanFileName);
    return _terjemahanDb!;
  }

  Future<Database> _initDb(String fileName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, fileName);

    // Cek apakah database sudah ada di sistem HP
    var exists = await databaseExists(path);

    if (!exists) {
      // Kalau belum ada, copy dari assets
      print("Menyalin database $fileName dari assets...");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets/databases", fileName));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Database $fileName sudah ada.");
    }

    return await openDatabase(path, readOnly: true);
  }

  // Contoh fungsi buat ngetes ambil data surah
  Future<List<Map<String, dynamic>>> getSurahList() async {
    final db = await getAlquranDb();
    // Di sini asumsi nama tabelnya 'sura' atau 'surah', nanti kita sesuaikan
    try {
      return await db.rawQuery('SELECT * FROM sura LIMIT 114');
    } catch (e) {
      print("Error ambil surah: $e");
      return [];
    }
  }
}
