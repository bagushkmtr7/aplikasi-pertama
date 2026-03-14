import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class SurahDetailScreen extends StatelessWidget {
  final int nomor;
  final String nama;
  const SurahDetailScreen({super.key, required this.nomor, required this.nama});

  @override
  Widget build(BuildContext context) {
    final ApiService api = ApiService();

    return Scaffold(
      appBar: AppBar(title: Text(nama)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: api.getSurahDetail(nomor),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final ayatList = snapshot.data!['ayat'] as List;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ayatList.length,
              itemBuilder: (context, i) {
                final ayat = ayatList[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(ayat['teksArab'], textAlign: TextAlign.right, 
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 2)),
                      const SizedBox(height: 12),
                      Align(alignment: Alignment.centerLeft, 
                        child: Text('${ayat['nomorAyat']}. ${ayat['teksIndonesia']}', 
                        style: const TextStyle(fontSize: 15, color: Colors.black87))),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
