import 'package:finance_tracker/currents/current_user.dart';
import 'package:finance_tracker/database/models/budgets.dart';
import 'package:finance_tracker/database/queries/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final currentBudgetProvider = Provider((ref) => CurrentBudget());

class CurrentBudget {
  Future<void> addBudget(WidgetRef ref, String category, double amount) async {
    final database = ref.watch(databaseProvider);
    final userProvider = ref.watch(currentUserProvider);
    final user = userProvider.getCurrentUser();
    Uuid uuid = const Uuid();
    String id = uuid.v4();

    Budgets budget = Budgets(
        id: id,
        userId: user!.id,
        categoryId: category,
        amount: amount,
        created: DateTime.now());

    await database.add('budgets', budget);
  }

  Future<void> updateBudget(
      WidgetRef ref, Budgets budget, double amount) async {
    final database = ref.watch(databaseProvider);

    Budgets newbudget = Budgets(
        id: budget.id,
        userId: budget.userId,
        categoryId: budget.categoryId,
        amount: amount,
        created: DateTime.now());

    await database.update('budgets', newbudget, budget.id);
  }

  Future<void> deleteBudget(WidgetRef ref, String id) async {
    final database = ref.watch(databaseProvider);

    await database.delete('budgets', id);
  }
}
