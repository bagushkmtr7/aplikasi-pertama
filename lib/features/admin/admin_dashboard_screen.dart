import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../../main.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('is_logged_in', false);
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const MainNavigation(initialIndex: 2)), (r) => false);
            }
          }),
        ],
      ),
      body: const Center(child: Text('Dashboard Offline Mode')),
    );
  }
}
