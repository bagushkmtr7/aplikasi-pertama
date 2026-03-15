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

  Future<Database> _getDb(String fileName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, fileName);
    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets/databases", fileName));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(path, readOnly: true);
  }

  Future<Database> getSuraSearchDb() async => _suraSearchDb ??= await _getDb('sura-search.db');
  Future<Database> getAlquranDb() async => _alquranDb ??= await _getDb('alquran.db');
  Future<Database> getLatinDb() async => _latinDb ??= await _getDb('latin.db');
  Future<Database> getTerjemahanDb() async => _terjemahanDb ??= await _getDb('terjemahan.db');
  Future<Database> getJalalaynDb() async => _jalalaynDb ??= await _getDb('jalalayn.db');
  Future<Database> getKataDb() async => _kataDb ??= await _getDb('kata.db');

  // Ambil Daftar Surah
  Future<List<Map<String, dynamic>>> getSurahList() async {
    final db = await getSuraSearchDb();
    return await db.query('data');
  }

  // Ambil Tafsir Jalalayn untuk satu ayat tertentu
  Future<String> getJalalayn(int suraId, int ayaId) async {
    final db = await getJalalaynDb();
    List<Map> results = await db.query(
      'data', 
      where: 'sura = ? AND aya = ?', 
      whereArgs: [suraId, ayaId]
    );
    return results.isNotEmpty ? results.first['text'] : "Tafsir tidak ditemukan.";
  }
}
