import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_service.dart';
import '../../data/surah_model.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});
  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final ApiService _api = ApiService();

  Future<void> _saveLastRead(String name, int number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_surah_name', name);
    await prefs.setInt('last_surah_number', number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Al-Qur\'an')),
      body: FutureBuilder<List<Surah>>(
        future: _api.getSurahs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          
          final surahs = snapshot.data!;
          return ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, i) {
              final s = surahs[i];
              return ListTile(
                leading: CircleAvatar(child: Text('${s.nomor}')),
                title: Text(s.namaLatin),
                subtitle: Text('${s.arti} (${s.jumlahAyat} Ayat)'),
                trailing: Text(s.nama, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                onTap: () async {
                  await _saveLastRead(s.namaLatin, s.nomor);
                  if (mounted) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (c) => SurahDetailScreen(nomor: s.nomor, nama: s.namaLatin)
                    ));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
