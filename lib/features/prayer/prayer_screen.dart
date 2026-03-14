import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_service.dart';
import '../../data/prayer_model.dart';
import '../../core/constants.dart';
import '../quran/surah_detail_screen.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});
  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final ApiService api = ApiService();
  String lastSurah = 'Belum ada';
  int lastNumber = 0;

  @override
  void initState() {
    super.initState();
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastSurah = prefs.getString('last_surah_name') ?? 'Belum ada';
      lastNumber = prefs.getInt('last_surah_number') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('NurDaily')),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([api.getPrayerTimes('Jakarta'), api.getAnnouncements()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final prayerTime = snapshot.data![0] as PrayerTime;
          final announcements = snapshot.data![1] as List<dynamic>;

          return RefreshIndicator(
            onRefresh: () async {
              _loadLastRead();
              setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // --- KARTU TERAKHIR BACA ---
                if (lastNumber != 0) Card(
                  color: Colors.orange[100],
                  child: ListTile(
                    leading: const Icon(Icons.bookmark, color: Colors.orange),
                    title: const Text('Terakhir Baca', style: TextStyle(fontSize: 12)),
                    subtitle: Text('Surah $lastSurah', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (c) => SurahDetailScreen(nomor: lastNumber, nama: lastSurah)
                    )),
                  ),
                ),
                const SizedBox(height: 16),
                
                const Text('Pengumuman Masjid', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                // (Slider Pengumuman lu tetep di sini...)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: announcements.length,
                    itemBuilder: (context, i) {
                      final info = announcements[i];
                      return Container(
                        width: 250,
                        margin: const EdgeInsets.only(right: 10),
                        child: Card(
                          color: AppColors.primary,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(info['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Jadwal Sholat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildPrayerRow('Subuh', prayerTime.subuh),
                _buildPrayerRow('Dzuhur', prayerTime.dzuhur),
                _buildPrayerRow('Ashar', prayerTime.ashar),
                _buildPrayerRow('Maghrib', prayerTime.maghrib),
                _buildPrayerRow('Isya', prayerTime.isya),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrayerRow(String name, String time) {
    return Card(child: ListTile(title: Text(name), trailing: Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))));
  }
}
