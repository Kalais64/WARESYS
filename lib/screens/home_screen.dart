import 'package:flutter/material.dart';
import 'monitoring/monitor_screen.dart';
import 'shared/profile_screen.dart';
import 'finances/finance_screen.dart';
import 'inventory/inventory_screen.dart';
import 'transaction/transaction_screen.dart';
import '../services/auth_service.dart';
// Import other screens as needed

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToMonitoring(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MonitorScreen()),
    );
}

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          moduleName: 'Dashboard',
          moduleColor: const Color(0xFF2E8B57),
          onBack: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _navigateToFinance(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FinanceScreen()),
    );
  }

  void _navigateToInventory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InventoryScreen()),
    );
  }

  void _navigateToTransaction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TransactionScreen()),
    );
  }

  void _logout(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Color(0xFF2E8B57)),
                    onPressed: () => _logout(context),
                  ),
                  const Text(
                    'More Modules',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E8B57),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, color: Color(0xFF2E8B57)),
                    onPressed: () => _navigateToProfile(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  children: [
                    GestureDetector(
                      onTap: () => _navigateToMonitoring(context),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.monitor_heart, color: Color(0xFF2E8B57), size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Monitoring',
                              style: TextStyle(
                                color: Color(0xFF2E8B57),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _navigateToTransaction(context),
                      child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.swap_horiz, color: Colors.blue, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Transaction',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _navigateToFinance(context),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.account_balance, color: Colors.teal, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Finances',
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _navigateToInventory(context),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                            ),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.warehouse, color: Colors.deepOrange, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Inventory',
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 8),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.grid_view, color: Color(0xFF2E8B57), size: 32),
                      SizedBox(width: 8),
                      Text(
                        'WARESYS',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF2E8B57),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardModule {
  final IconData icon;
  final String label;
  const _DashboardModule({required this.icon, required this.label});
}