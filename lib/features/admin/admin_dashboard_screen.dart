import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';
import '../../main.dart'; // Import main buat akses MainNavigation
import 'manage_announcement_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), 
            onPressed: () async {
              // 1. Proses Logout dari Supabase
              await Supabase.instance.client.auth.signOut();
              
              if (context.mounted) {
                // 2. Balik ke MainNavigation dan buka Tab Admin (Index 2)
                // pushAndRemoveUntil gunanya biar user gak bisa klik "back" balik ke admin lagi
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) => const MainNavigation(initialIndex: 2)),
                  (route) => false
                );
              }
            }
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          _buildAdminCard(context, Icons.campaign, 'Pengumuman', const ManageAnnouncementScreen()),
          _buildAdminCard(context, Icons.edit_calendar, 'Jadwal Lokal', null),
          _buildAdminCard(context, Icons.people, 'Jamaah', null),
          _buildAdminCard(context, Icons.volunteer_activism, 'Donasi', null),
        ],
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, IconData icon, String title, Widget? target) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () { if (target != null) Navigator.push(context, MaterialPageRoute(builder: (context) => target)); },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
