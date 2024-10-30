import 'package:finance_tracker/currents/current_account.dart';
import 'package:finance_tracker/currents/current_user.dart';
import 'package:finance_tracker/database/models/budgets.dart';
import 'package:finance_tracker/database/models/categories.dart';
import 'package:finance_tracker/database/models/transactions.dart';
import 'package:finance_tracker/database/queries/database.dart';
import 'package:finance_tracker/features/dashboard/builds/buid_mobile_app_bar.dart';
import 'package:finance_tracker/features/dashboard/user_budgets.dart';
import 'package:finance_tracker/features/dashboard/user_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'build_home.dart';

class MobileDashboard extends ConsumerStatefulWidget {
  const MobileDashboard({super.key});

  @override
  ConsumerState<MobileDashboard> createState() => _MobileDashboardState();
}

class _MobileDashboardState extends ConsumerState<MobileDashboard> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // Initially setting _pages as empty; will populate later
    _pages = <Widget>[
      const BuildHome(),
      const Center(
          child:
              CircularProgressIndicator()), // Placeholder until data is loaded
      const Center(child: CircularProgressIndicator()),
    ];
    _loadData(); // Load data aHsynchronously
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
        const BuildHome(),
        UserTransactions(
            transactionList: transactionList, categoryList: categoryList),
        UserBudgets(budgetList: budgetList, categoryList: categoryList),
      ];
    });
  }

  // Function to handle the change in selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(currentUserProvider);
    final user = userProvider.getCurrentUser();
    final accountProvider = ref.watch(currentAccountProvider);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: buildAppBar(accountProvider, user),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budgets',
          ),
        ],
        currentIndex: _selectedIndex, // Selected item index
        selectedItemColor: Colors.teal, // Color of the selected item
        onTap: _onItemTapped, // Handle tapping on items
      ),
    );
  }
}
