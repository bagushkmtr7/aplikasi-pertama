import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/surah_model.dart';
import '../data/prayer_model.dart';

class ApiService {
  final _supabase = Supabase.instance.client;
  static const String _baseUrlQuran = 'https://equran.id/api/v2';
  static const String _baseUrlPrayer = 'https://api.aladhan.com/v1';

  // --- AUTH ---
  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  // --- PENGUMUMAN (DENGAN LOG ERROR) ---
  Future<List<dynamic>> getAnnouncements() async {
    try {
      final response = await _supabase.from('announcements').select().order('created_at');
      return response as List<dynamic>;
    } catch (e) {
      print('Error Get Data: $e');
      return [];
    }
  }

  Future<void> addAnnouncement(String title, String content) async {
    try {
      await _supabase.from('announcements').insert({
        'title': title,
        'content': content,
      });
      print('Berhasil Simpan!');
    } catch (e) {
      print('Error Simpan Data: $e');
      rethrow; // Biar UI tau kalau error
    }
  }

  Future<void> deleteAnnouncement(int id) async {
    await _supabase.from('announcements').delete().match({'id': id});
  }

  // --- QURAN & PRAYER ---
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
}
