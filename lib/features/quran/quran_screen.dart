import 'package:flutter/material.dart';
import '../../core/database/db_helper.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final DbHelper _dbHelper = DbHelper();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AL-QUR\'AN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.getSurahList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          }
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final surahs = snapshot.data ?? [];

          return ListView.separated(
            itemCount: surahs.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text('${surah['id']}', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                ),
                title: Text(
                  surah['latin'] ?? 'Surah',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text('${surah['location']} • ${surah['ayah']} Ayat', style: TextStyle(color: Colors.grey.shade600)),
                trailing: Text(
                  surah['arabic'] ?? '',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                onTap: () {
                  // Nanti kita buat navigasi ke detail ayat
                },
              );
            },
          );
        },
      ),
    );
  }
}
