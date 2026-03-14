import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/surah_model.dart';
import '../data/prayer_model.dart';

class ApiService {
  static const String _baseUrlQuran = 'https://equran.id/api/v2';
  static const String _baseUrlPrayer = 'https://api.aladhan.com/v1';

  // --- QURAN & PRAYER (KEEP WORKING) ---
  Future<List<Surah>> getSurahs() async {
    final res = await http.get(Uri.parse('$_baseUrlQuran/surat'));
    if (res.statusCode == 200) {
      List data = json.decode(res.body)['data'];
      return data.map((s) => Surah.fromJson(s)).toList();
    }
    throw Exception('Gagal ambil Surah');
  }

  Future<Map<String, dynamic>> getSurahDetail(int nomor) async {
    final res = await http.get(Uri.parse('$_baseUrlQuran/surat/$nomor'));
    if (res.statusCode == 200) return json.decode(res.body)['data'];
    throw Exception('Gagal ambil detail');
  }

  Future<PrayerTime> getPrayerTimes(String city) async {
    final res = await http.get(Uri.parse('$_baseUrlPrayer/timingsByCity?city=$city&country=Indonesia&method=2'));
    if (res.statusCode == 200) return PrayerTime.fromJson(json.decode(res.body)['data']['timings']);
    throw Exception('Gagal ambil jadwal');
  }

  // --- DUMMY DATA FOR OFFLINE TEST ---
  Future<List<dynamic>> getAnnouncements() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {'id': 1, 'title': 'Ramadhan Kareem', 'content': 'Selamat menunaikan ibadah puasa Ham!'},
      {'id': 2, 'title': 'Info Kajian', 'content': 'Kajian rutin ditiadakan sementara.'},
    ];
  }
}
