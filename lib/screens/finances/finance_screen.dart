import 'package:flutter/material.dart';
import '../shared/profile_screen.dart';
import 'finance_overview_page.dart';
import 'finance_transactions_page.dart';
import 'finance_budgets_page.dart';
import 'finance_reports_page.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    FinanceOverviewPage(),
    FinanceTransactionsPage(),
    FinanceBudgetsPage(),
    FinanceReportsPage(),
  ];

  static const List<String> _titles = <String>[
    'Overview',
    'Transactions',
    'Budgets',
    'Reports',
  ];

  static const List<Color> _colors = <Color>[
    Color(0xFF00897B), // Overview - teal[700]
    Colors.blue,        // Transactions
    Colors.amber,       // Budgets
    Colors.deepPurple,  // Reports
    Color(0xFF00897B), // Profile (same as module)
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      // Show profile screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            moduleName: 'Finances',
            moduleColor: _colors[4],
            onBack: () => Navigator.pop(context),
          ),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: _colors[_selectedIndex],
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: _colors[_selectedIndex],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_vert),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budgets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
} 