import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _suraSearchDb;
  static Database? _alquranDb;
  static Database? _surahInfoDb;

  Future<Database> _initDatabase(String fileName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, fileName);
    
    if (await File(path).exists()) {
      await deleteDatabase(path);
    }

    try {
      await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load("assets/databases/$fileName");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } catch (e) {
      print("Gagal copy $fileName: $e");
    }

    return await openDatabase(path, readOnly: true);
  }

  Future<Database> getSuraSearchDb() async => _suraSearchDb ??= await _initDatabase('sura-search.db');
  Future<Database> getAlquranDb() async => _alquranDb ??= await _initDatabase('alquran.db');
  Future<Database> getSurahInfoDb() async => _surahInfoDb ??= await _initDatabase('surah_info.db');

  Future<List<Map<String, dynamic>>> getFullSurahData() async {
    final searchDb = await getSuraSearchDb();
    final quranDb = await getAlquranDb();
    final infoDb = await getSurahInfoDb();

    List<Map<String, dynamic>> surahNames = await searchDb.query('sura_search');
    List<Map<String, dynamic>> locations = await infoDb.query('info');
    List<Map<String, dynamic>> counts = await quranDb.rawQuery(
      'SELECT sura, COUNT(*) as total FROM quran GROUP BY sura'
    );

    return surahNames.map((s) {
      int no = s['no'];
      var locData = locations.firstWhere((l) => l['no'] == no, orElse: () => {'location': 'Mekkah'});
      var countData = counts.firstWhere((c) => c['sura'] == no, orElse: () => {'total': 0});
      
      return {
        ...s,
        'location': locData['location'],
        'total_verses': countData['total'],
      };
    }).toList();
  }
}
