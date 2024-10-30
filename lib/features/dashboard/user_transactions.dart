import 'package:finance_tracker/currents/current_transaction.dart';
import 'package:finance_tracker/features/dashboard/cards/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/models/categories.dart';
import '../../database/models/transactions.dart';

class UserTransactions extends ConsumerStatefulWidget {
  final List<Transactions> transactionList;
  final List<Categories> categoryList;

  const UserTransactions({
    super.key,
    required this.transactionList,
    required this.categoryList,
  });

  @override
  ConsumerState<UserTransactions> createState() => _UserTransactionsState();
}

class _UserTransactionsState extends ConsumerState<UserTransactions> {
  String searchCategory = '';

  @override
  Widget build(BuildContext context) {
    ref.watch(currentTransactionProvider);
    // Creating a map of categoryId to categoryName for easy lookup
    Map<String, String> categoryMap = {
      for (var category in widget.categoryList) category.id: category.name
    };

    // Group transactions by categoryId
    Map<String, List<Transactions>> groupedTransactions = {};
    for (Transactions transaction in widget.transactionList) {
      if (!groupedTransactions.containsKey(transaction.categoryId)) {
        groupedTransactions[transaction.categoryId] = [];
      }
      groupedTransactions[transaction.categoryId]!.add(transaction);
    }

    return Stack(
      children: [
        Container(
          color: Colors.teal[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  "All Transactions",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 18.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchCategory = value.toLowerCase();
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: groupedTransactions.entries
                      .where((entry) =>
                          searchCategory.isEmpty ||
                          (categoryMap[entry.key]
                                  ?.toLowerCase()
                                  .contains(searchCategory) ??
                              false))
                      .map((entry) {
                    String categoryName = categoryMap[entry.key] ??
                        'Unknown Category'; // Default value
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // List of transactions in this category
                        ...entry.value.map((transaction) {
                          return TransactionCard(
                              transaction: transaction, category: categoryName);
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              _showAddTransactionModal(context, ref);
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  // Function to show the modal bottom sheet for adding a transaction
  void _showAddTransactionModal(BuildContext context, WidgetRef ref) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String? selectedCategoryId;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Transaction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategoryId,
                hint: const Text('Select Category'),
                items: widget.categoryList.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  double? amount = double.tryParse(amountController.text);
                  String description = descriptionController.text;

                  if (selectedCategoryId != null &&
                      amount != null &&
                      description.isNotEmpty) {
                    // Add the transaction to the provider
                    ref.read(currentTransactionProvider).addTransaction(
                          ref,
                          selectedCategoryId!,
                          amount,
                          description,
                        );
                    Navigator.pop(context); // Close the modal
                  }
                },
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        );
      },
    );
  }
}
