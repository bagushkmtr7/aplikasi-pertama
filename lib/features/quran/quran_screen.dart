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
    // Definisi Warna sesuai Gambar Referensi
    const Color primaryGreen = Color(0xFF1B4D3E); // Hijau Tua AppBar
    const Color goldText = Color(0xFFBCA37F);    // Warna cokelat/emas subtitle
    const Color bgColor = Color(0xFFFDFBF8);     // Background krem halus

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Baca Qur\'an', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.playlist_play, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar Dummy (biar mirip gambar)
          Container(
            color: primaryGreen,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('SURAH', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, border: Border(bottom: BorderSide(color: goldText, width: 3)))),
                  Text('JUZ', style: TextStyle(color: Colors.white70)),
                  Text('BOOKMARK', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
          // List Surah
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _dbHelper.getFullSurahData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: primaryGreen));
                
                final surahs = snapshot.data ?? [];
                return ListView.separated(
                  itemCount: surahs.length,
                  separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                  itemBuilder: (context, index) {
                    final surah = surahs[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: SizedBox(
                        width: 45,
                        height: 45,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Icon Bintang Segi Delapan
                            Transform.rotate(
                              angle: 0.8,
                              child: Icon(Icons.square, color: goldText.withOpacity(0.2), size: 30),
                            ),
                            const Icon(Icons.square, color: Colors.transparent, size: 30),
                            Icon(Icons.brightness_7_outlined, color: goldText, size: 40),
                            Text('${surah['no']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryGreen)),
                          ],
                        ),
                      ),
                      title: Text(
                        '${surah['indonesia']}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
                      ),
                      subtitle: Text(
                        '${surah['location'].toUpperCase()} | ${surah['total_verses']} AYAT',
                        style: const TextStyle(color: goldText, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${surah['arabic']}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: 'Arabic'),
                          ),
                          const SizedBox(width: 15),
                          const Icon(Icons.download_for_offline_outlined, color: Color(0xFF609966), size: 22),
                        ],
                      ),
                      onTap: () {
                        // TODO: Navigasi ke Detail
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
