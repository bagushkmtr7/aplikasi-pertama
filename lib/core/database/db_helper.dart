import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _suraSearchDb;
  static Database? _alquranDb;
  static Database? _latinDb;
  static Database? _terjemahanDb;
  static Database? _jalalaynDb;
  static Database? _kataDb;

  Future<Database> _initDatabase(String fileName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, fileName);

    // LOGIC BARU: Cek ukuran file. Kalau 0 atau gak ada, kita copy ulang.
    bool exists = await databaseExists(path);
    
    if (!exists) {
      print("Database $fileName belum ada, mulai menyalin...");
      await _copyDatabase(fileName, path);
    } else {
      // Cek kalau-kalau filenya corrupt (ukurannya 0)
      File f = File(path);
      if (await f.length() == 0) {
        print("Database $fileName kosong, menyalin ulang...");
        await _copyDatabase(fileName, path);
      }
    }

    return await openDatabase(path, readOnly: true);
  }

  Future<void> _copyDatabase(String fileName, String path) async {
    try {
      await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load("assets/databases/$fileName");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      print("Berhasil menyalin $fileName");
    } catch (e) {
      print("Gagal menyalin $fileName: $e");
    }
  }

  Future<Database> getSuraSearchDb() async => _suraSearchDb ??= await _initDatabase('sura-search.db');
  Future<Database> getAlquranDb() async => _alquranDb ??= await _initDatabase('alquran.db');
  Future<Database> getLatinDb() async => _latinDb ??= await _initDatabase('latin.db');
  Future<Database> getTerjemahanDb() async => _terjemahanDb ??= await _initDatabase('terjemahan.db');
  Future<Database> getJalalaynDb() async => _jalalaynDb ??= await _initDatabase('jalalayn.db');
  Future<Database> getKataDb() async => _kataDb ??= await _initDatabase('kata.db');

  Future<List<Map<String, dynamic>>> getSurahList() async {
    final db = await getSuraSearchDb();
    // Berdasarkan screenshot lu, nama tabelnya 'data'
    return await db.query('data');
  }
}
