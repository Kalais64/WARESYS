import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import 'transaction_list_page.dart';
import '../shared/profile_screen.dart';
import 'transaction_export_page.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    TransactionListPage(type: TransactionType.sales),
    TransactionListPage(type: TransactionType.purchase),
    TransactionExportPage(),
    // Profile handled in _onItemTapped
  ];

  static const List<String> _titles = <String>[
    'Sales',
    'Purchase',
    'Export',
  ];

  static const List<Color> _colors = <Color>[
    Colors.blue,        // Sales
    Colors.green,       // Purchase
    Colors.orange,      // Export
    Colors.blue,        // Profile (same as module)
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            moduleName: 'Transaction',
            moduleColor: _colors[3],
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
            icon: Icon(Icons.point_of_sale),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Purchase',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_download),
            label: 'Export',
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