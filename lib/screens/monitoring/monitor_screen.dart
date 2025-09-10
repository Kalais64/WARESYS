import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waresys_fix1/providers/auth_provider.dart';
import 'package:waresys_fix1/providers/transaction_provider.dart';
import 'package:waresys_fix1/providers/inventory_provider.dart';
import 'package:waresys_fix1/screens/monitoring/monitor_overview_page.dart';
import 'package:waresys_fix1/screens/monitoring/monitor_activity_page.dart';
import 'package:waresys_fix1/screens/monitoring/monitor_notifications_page.dart';
import 'package:waresys_fix1/screens/monitoring/monitor_charts_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart' as badges;
import 'package:waresys_fix1/services/finance_service.dart';
import 'package:waresys_fix1/services/monitoring_service.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  int _selectedIndex = 0;
  bool _isRefreshing = false;
  final _financeService = FinanceService();
  final _monitoringService = MonitoringService();
  
  final List<Widget> _pages = [
    const MonitorOverviewPage(),
    const MonitorChartsPage(),
    const MonitorActivityPage(),
    const MonitorNotificationsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
      final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);

      await Future.wait([
        transactionProvider.loadTransactions(),
        inventoryProvider.loadProducts(),
      ]);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data refreshed successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error refreshing data: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monitoring',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_selectedIndex == 0)
              Row(
                children: [
                  Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white70),
                  SizedBox(width: 4),
                  Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
          ],
        ),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () async {
                // Date picker functionality will be handled in MonitorOverviewPage
              },
            ),
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isRefreshing ? null : _refreshData,
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: StreamBuilder<int>(
        stream: _monitoringService.getUnreadNotificationsCount(),
        builder: (context, snapshot) {
          final unreadCount = snapshot.data ?? 0;
          
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Overview',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined),
                activeIcon: Icon(Icons.bar_chart),
                label: 'Charts',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                activeIcon: Icon(Icons.list_alt),
                label: 'Activity',
              ),
              BottomNavigationBarItem(
                icon: unreadCount > 0
                  ? badges.Badge(
                      badgeContent: Text(
                        unreadCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Colors.red,
                        padding: const EdgeInsets.all(5),
                      ),
                      child: const Icon(Icons.notifications_outlined),
                    )
                  : const Icon(Icons.notifications_outlined),
                activeIcon: unreadCount > 0
                  ? badges.Badge(
                      badgeContent: Text(
                        unreadCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Colors.red,
                        padding: const EdgeInsets.all(5),
                      ),
                      child: const Icon(Icons.notifications),
                    )
                  : const Icon(Icons.notifications),
                label: 'Alerts',
              ),
            ],
          );
        }
      ),
    );
  }
}
