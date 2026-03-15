import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/constants.dart';
import '../../main.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _api = ApiService();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _addInfo() async {
    if (_titleController.text.isEmpty) return;
    await _api.addAnnouncement(_titleController.text, _contentController.text);
    _titleController.clear();
    _contentController.clear();
    if (mounted) setState(() {}); // Refresh list
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengumuman Ditambahkan!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin NurDaily'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _api.signOut();
              if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const MainNavigation(initialIndex: 0)));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Judul Pengumuman')),
            TextField(controller: _contentController, decoration: const InputDecoration(labelText: 'Isi Pengumuman')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addInfo, child: const Text('POSTING KE MASJID')),
            const Divider(height: 40),
            const Text('Pengumuman Aktif', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _api.getAnnouncements(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (c, i) => ListTile(
                      title: Text(snapshot.data![i]['title']),
                      subtitle: Text(snapshot.data![i]['content']),
                      trailing: const Icon(Icons. campaign, color: AppColors.primary),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
