import 'package:finance_tracker/currents/category_details.dart';
import 'package:finance_tracker/database/models/budgets.dart';
import 'package:finance_tracker/database/models/categories.dart';
import 'package:finance_tracker/database/models/transactions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/queries/database.dart';

// Define the provider for CurrentCategory
final currentCategoryProvider = Provider<CurrentCategory>((ref) {
  return CurrentCategory(categories: []);
});

class CurrentCategory {
  List<Categories>? categories;

  CurrentCategory({required this.categories});

  void setCategories(List<Categories> allCategories) {
    categories = allCategories;
  }

  Future<Map<String, Budgets>> getBudgetsByCategory(WidgetRef ref) async {
    final database = ref.watch(databaseProvider);
    final allBudgets = await database.get('budgets');

    final budgets = allBudgets.map<Budgets>((budget) {
      return Budgets.fromMap(budget);
    }).toList();

    Map<String, Budgets> sortedBudgets = {};

    for (var budget in budgets) {
      sortedBudgets[budget.categoryId] = budget;
    }

    return sortedBudgets;
  }

  Future<List<Transactions>> getTransactionsByCategory(
      WidgetRef ref, String categoryId) async {
    final database = ref.watch(databaseProvider);
    final allTransaction = await database.get('transactions');

    // Convert each transaction to the Transactions model
    final transactions = allTransaction.map<Transactions>((transaction) {
      return Transactions.fromMap(transaction);
    }).toList();

    // Filter transactions by the given categoryId
    return transactions
        .where((transaction) => transaction.categoryId == categoryId)
        .toList();
  }

  Future<Map<String, CategoryDetails>> getAllCategoryDetails(
      WidgetRef ref) async {
    var allBudgetDetails = await getBudgetsByCategory(ref);

    // Combine budgets and transactions based on categoryId
    Map<String, CategoryDetails> allCategoryDetails = {};

    for (var key in allBudgetDetails.keys) {
      // Get transactions for this category
      var transactionList = await getTransactionsByCategory(ref, key);

      // Get budget for this category
      var budget = allBudgetDetails[key];

      // Handle cases where categories might be null or empty
      if (categories != null && categories!.isNotEmpty) {
        // Find the corresponding category
        var category = categories!.firstWhere(
          (cat) => cat.id == key,
          orElse: () => Categories(
              id: key,
              userId: '0',
              name: 'Unknown Category'), // fallback if category not found
        );

        // Add CategoryDetails to the map
        allCategoryDetails[category.id] = CategoryDetails(
          categories: category,
          transactionList: transactionList,
          budgets: budget!, // Ensure that budget is non-null
        );
      }
    }

    return allCategoryDetails;
  }
}
