import 'package:finance_tracker/currents/current_account.dart';
import 'package:finance_tracker/currents/current_user.dart';
import 'package:finance_tracker/database/models/budgets.dart';
import 'package:finance_tracker/database/models/categories.dart';
import 'package:finance_tracker/database/models/transactions.dart';
import 'package:finance_tracker/database/queries/database.dart';
import 'package:finance_tracker/features/dashboard/user_budgets.dart';
import 'package:finance_tracker/features/dashboard/user_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'build_home.dart';

class DesktopDashboard extends ConsumerStatefulWidget {
  const DesktopDashboard({super.key});

  @override
  ConsumerState<DesktopDashboard> createState() => _DesktopDashboardState();
}

class _DesktopDashboardState extends ConsumerState<DesktopDashboard> {
  int _selectedIndex = 0; // Tracks the current sidebar selection
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const Center(child: CircularProgressIndicator()), // Placeholder
      const Center(child: CircularProgressIndicator()), // Placeholder
      const Center(child: CircularProgressIndicator()), // Placeholder
    ];
    _loadData(); // Load data asynchronously
  }

  // Function to load data asynchronously
  Future<void> _loadData() async {
    final database = ref.read(databaseProvider);

    final transactions = await database.get('transactions');
    final transactionList = transactions.map((transaction) {
      return Transactions.fromMap(transaction);
    }).toList();

    final budgets = await database.get('budgets');
    final budgetList = budgets.map((budget) {
      return Budgets.fromMap(budget);
    }).toList();

    final categories = await database.get('categories');
    final categoryList = categories.map((category) {
      return Categories.fromMap(category);
    }).toList();

    // Once data is loaded, update _pages
    setState(() {
      _pages = <Widget>[
        UserTransactions(
            transactionList: transactionList, categoryList: categoryList),
        UserBudgets(budgetList: budgetList, categoryList: categoryList),
        const BuildHome(), // Assuming this is the third page
      ];
    });
  }

  // Method to update the selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(currentUserProvider);
    final user = userProvider.getCurrentUser();
    ref.watch(currentAccountProvider);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
      ),
      body: Row(
        children: [
          // Sidebar Navigation
          NavigationRail(
            backgroundColor: Colors.grey[200],
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.account_balance_wallet),
                label: Text('Transactions'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.pie_chart),
                label: Text('Budgets'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
            ],
          ),
          const VerticalDivider(
              thickness: 1, width: 1), // Divider between sidebar and content

          // Main Content (Selected Page)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
