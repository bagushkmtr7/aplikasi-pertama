import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/constants.dart';
import 'features/prayer/prayer_screen.dart';
import 'features/quran/quran_screen.dart';
import 'features/auth/login_screen.dart';

// Fungsi buat handle pesan pas aplikasi di background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    
    // Minta ijin notifikasi ke user
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    
    // Dengerin pesan pas aplikasi lagi kebuka
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Dapet pesan: ${message.notification?.title}');
    });

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
      home: const MainNavigation(),
    );
  }
}

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
