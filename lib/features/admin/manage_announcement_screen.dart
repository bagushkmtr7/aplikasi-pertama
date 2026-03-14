import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/constants.dart';

class ManageAnnouncementScreen extends StatefulWidget {
  const ManageAnnouncementScreen({super.key});
  @override
  State<ManageAnnouncementScreen> createState() => _ManageAnnouncementScreenState();
}

class _ManageAnnouncementScreenState extends State<ManageAnnouncementScreen> {
  final ApiService _api = ApiService();

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Pengumuman')),
      body: FutureBuilder<List<dynamic>>(
        future: _api.getAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Belum ada pengumuman'));

          final list = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final item = list[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.campaign, color: AppColors.primary),
                  title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['content']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _api.deleteAnnouncement(item['id']);
                      _refresh();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Pengumuman'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Judul')),
            TextField(controller: contentCtrl, decoration: const InputDecoration(labelText: 'Isi Pengumuman')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              await _api.addAnnouncement(titleCtrl.text, contentCtrl.text);
              if (mounted) {
                Navigator.pop(context);
                _refresh();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
