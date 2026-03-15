import 'package:flutter/material.dart';
import 'dart:ui'; // Wajib buat efek blur background
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Import halaman-halaman fitur lu
import 'core/constants.dart';
import 'features/prayer/prayer_screen.dart';
import 'features/quran/quran_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/duas/dua_list_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    print("Firebase Error: $e");
  }
  runApp(const NurDailyApp());
}

class NurDailyApp extends StatelessWidget {
  const NurDailyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NurDaily',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      // HALAMAN PERTAMA KALI DIBUKA ADALAH HOME SCREEN
      home: const HomeScreen(), 
    );
  }
}

// ==========================================
// 1. HALAMAN DEPAN (HOME SCREEN) - Sesuai Referensi Lu
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gambar Mekah Lu
          Image.asset(
            'assets/images/imgmekah.png',
            fit: BoxFit.cover,
          ),
          
          // Efek Blur & Gelap
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              color: Colors.black.withOpacity(0.55),
            ),
          ),
          
          // Konten Tengah
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "القرآن الكريم",
                      style: TextStyle(
                        fontSize: 45,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Icon(
                      Icons.menu_book,
                      size: 50,
                      color: Color(0xFF4DB6AC), // Warna Teal
                    ),
                    const SizedBox(height: 60),
                    
                    // Tombol-tombol Menu
                    _buildMenuButton(context, "BACA QUR'AN", () {
                      // Masuk ke Menu Al-Qur'an (Index 1)
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation(initialIndex: 1)));
                    }),
                    _buildMenuButton(context, "TERAKHIR BACA", () {}),
                    _buildMenuButton(context, "PENCARIAN", () {}),
                    _buildMenuButton(context, "JADWAL SHOLAT", () {
                      // Masuk ke Menu Jadwal Sholat (Index 0)
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation(initialIndex: 0)));
                    }),
                    _buildMenuButton(context, "PENGATURAN", () {}),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Desain Tombol Kotak Transparan Garis Putih
  Widget _buildMenuButton(BuildContext context, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. NAVIGASI BAWAH (SETELAH MASUK MENU)
// ==========================================
class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;
  final List<Widget> _screens = [
    const PrayerScreen(),
    const QuranScreen(),
    const DuaListScreen(),
    const LoginScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Sholat'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Qur\'an'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Doa'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
        ],
      ),
    );
  }
}
