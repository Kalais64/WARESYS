import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Import Provider baru kita
import 'package:waresys_fix1/providers/ai_provider.dart';

import 'package:waresys_fix1/providers/auth_provider.dart';
import 'package:waresys_fix1/providers/transaction_provider.dart';
import 'package:waresys_fix1/providers/inventory_provider.dart';
import 'package:waresys_fix1/screens/welcome_screen.dart';
import 'package:waresys_fix1/screens/login_screen.dart';
import 'package:waresys_fix1/screens/login_options_screen.dart';
import 'package:waresys_fix1/screens/register_screen.dart';
import 'package:waresys_fix1/screens/home_screen.dart';
import 'package:waresys_fix1/screens/admin_home_screen.dart';
import 'package:waresys_fix1/screens/monitoring/monitor_screen.dart';
import 'package:waresys_fix1/screens/monitoring/monitor_notifications_page.dart';
import 'package:waresys_fix1/screens/monitoring/monitor_activity_page.dart';
import 'package:waresys_fix1/screens/finances/finance_screen.dart';
import 'package:waresys_fix1/screens/inventory/inventory_screen.dart';
import 'package:waresys_fix1/constants/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Kita pisahkan inisialisasi Firebase agar lebih fokus
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        // Daftarkan AIProvider kita di sini
        ChangeNotifierProvider(create: (_) => AIProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waresys',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.light(
          primary: AppTheme.primaryGreen,
          secondary: AppTheme.secondaryGreen,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      // Kita tidak lagi pakai initialRoute, tapi langsung menunjuk ke SplashScreen
      home: const SplashScreen(),
      // Routes tetap ada untuk navigasi setelah aplikasi berjalan
      routes: {
        '/welcome': (context) => const WelcomeScreen(), // Ganti rute '/' menjadi '/welcome'
        '/login': (context) => const LoginScreen(),
        '/login-options': (context) => const LoginOptionsScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminHomeScreen(),
        '/monitor': (context) => const MonitorScreen(),
        '/monitor/notifications': (context) => const MonitorNotificationsPage(),
        '/monitor/activity': (context) => const MonitorActivityPage(),
        '/finances': (context) => const FinanceScreen(),
        '/inventory': (context) => const InventoryScreen(),
      },
    );
  }
}

// --- LAYAR BARU: "Dapur" untuk Inisialisasi ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Panggil inisialisasi AI dari AIProvider
      await Provider.of<AIProvider>(context, listen: false).initialize();

      // Setelah selesai, arahkan ke halaman selamat datang
      // 'pushReplacementNamed' agar pengguna tidak bisa kembali ke splash screen
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/welcome');
      }
    } catch (e) {
      // Jika GAGAL, tampilkan dialog error
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Initialization Failed'),
            content: Text('Could not initialize application services: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Selama inisialisasi, tampilkan logo dan loading indicator
    return const Scaffold(
      backgroundColor: AppTheme.primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kamu bisa ganti dengan logo Waresys di sini
            Icon(Icons.warehouse_rounded, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Waresys',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
