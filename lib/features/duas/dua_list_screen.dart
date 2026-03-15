import 'package:flutter/material.dart';
import '../../core/dua_service.dart';
import '../../data/dua_model.dart';
import '../../core/constants.dart';

class DuaListScreen extends StatefulWidget {
  const DuaListScreen({super.key});

  @override
  State<DuaListScreen> createState() => _DuaListScreenState();
}

class _DuaListScreenState extends State<DuaListScreen> {
  final DuaService _duaService = DuaService();
  late Future<List<DuaModel>> _duasFuture;

  @override
  void initState() {
    super.initState();
    // Panggil API-nya pas halaman pertama kali dibuka
    _duasFuture = _duaService.getAllDuas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Kumpulan Doa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: FutureBuilder<List<DuaModel>>(
        future: _duasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Duh, gagal ngambil data nih: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data doa kosong dari API-nya.'));
          }

          final duas = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: duas.length,
            itemBuilder: (context, index) {
              final dua = duas[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
                child: ExpansionTile(
                  title: Text(dua.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            dua.arabic,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 2.0),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            dua.latin,
                            style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.teal, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dua.translation,
                            style: const TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
