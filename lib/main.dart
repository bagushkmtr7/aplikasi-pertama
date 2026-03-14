import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants.dart';
import 'features/prayer/prayer_screen.dart';
import 'features/quran/quran_screen.dart';
import 'features/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://pjoyhfsdwsssqfxrcdfy.supabase.co',
    anonKey: 'sb_publishable_tyF5rFufymK_rh4R3VXTiw_iA1Yc18p',
  );
  runApp(const NurDailyApp());
}

class NurDailyApp extends StatelessWidget {
  const NurDailyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NurDaily',
      theme: AppTheme.light,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final int initialIndex; // Tambahan buat kontrol tab
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Set tab sesuai perintah
  }

  static const List<Widget> _pages = [
    PrayerScreen(),
    QuranScreen(),
    LoginScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Sholat'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Al-Qur\'an'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
        ],
      ),
    );
  }
}
