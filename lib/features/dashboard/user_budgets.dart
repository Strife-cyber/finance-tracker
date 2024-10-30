import 'package:finance_tracker/currents/current_budget.dart';
import 'package:finance_tracker/currents/current_category.dart';
import 'package:finance_tracker/database/models/budgets.dart';
import 'package:finance_tracker/database/models/categories.dart';
import 'package:finance_tracker/features/dashboard/cards/budget_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../currents/category_details.dart';

class UserBudgets extends ConsumerStatefulWidget {
  final List<Budgets> budgetList;
  final List<Categories> categoryList;

  const UserBudgets(
      {super.key, required this.budgetList, required this.categoryList});

  @override
  ConsumerState<UserBudgets> createState() => _UserBudgetsState();
}

class _UserBudgetsState extends ConsumerState<UserBudgets> {
  String searchCategory = '';

  @override
  Widget build(BuildContext context) {
    final currentCategory = ref.watch(currentCategoryProvider);
    currentCategory.setCategories(widget.categoryList);
    ref.watch(currentBudgetProvider);

    return FutureBuilder<Map<String, CategoryDetails>>(
      future: currentCategory.getAllCategoryDetails(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        }

        final allCategoryData = snapshot.data ?? {};
        Map<String, String> categoryMap = {
          for (var category in widget.categoryList) category.id: category.name
        };

        Map<String, List<Budgets>> groupedBudgets = {};
        for (var budget in widget.budgetList) {
          if (!groupedBudgets.containsKey(budget.categoryId)) {
            groupedBudgets[budget.categoryId] = [];
          }
          groupedBudgets[budget.categoryId]!.add(budget);
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
                      "All Budgets",
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
                      children: groupedBudgets.entries
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
                            ...entry.value.map((budget) {
                              final categoryDetails =
                                  allCategoryData[entry.key];
                              if (categoryDetails != null) {
                                return BudgetCard(
                                  category: categoryName,
                                  budget: budget,
                                  details: categoryDetails,
                                );
                              } else {
                                return const SizedBox(); // Handle missing details gracefully
                              }
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
                  _showAddBudgetModal(context, ref);
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to show the modal bottom sheet for adding a budget
  void _showAddBudgetModal(BuildContext context, WidgetRef ref) {
    final TextEditingController amountController = TextEditingController();
    String? selectedCategoryId;
    ref.read(currentCategoryProvider);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Budget',
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
              ElevatedButton(
                onPressed: () {
                  double? amount = double.tryParse(amountController.text);
                  if (selectedCategoryId != null && amount != null) {
                    // Add the budget to the provider
                    ref.read(currentBudgetProvider).addBudget(
                          ref,
                          selectedCategoryId!,
                          amount,
                        );
                    Navigator.pop(context); // Close the modal
                  }
                },
                child: const Text('Add Budget'),
              ),
            ],
          ),
        );
      },
    );
  }
}
