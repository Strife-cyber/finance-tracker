import 'package:finance_tracker/currents/current_account.dart';
import 'package:finance_tracker/currents/current_user.dart';
import 'package:finance_tracker/database/models/transactions.dart';
import 'package:finance_tracker/database/queries/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final currentTransactionProvider = Provider((ref) => CurrentTransaction());

class CurrentTransaction {
  Future<void> addTransaction(
      WidgetRef ref, String category, double amount, String description) async {
    final database = ref.watch(databaseProvider);
    final userProvider = ref.watch(currentUserProvider);
    final user = userProvider.getCurrentUser();
    final accountProvider = ref.watch(currentAccountProvider);
    final account = accountProvider.accounts;
    Uuid uuid = const Uuid();
    String id = uuid.v4();

    Transactions transaction = Transactions(
        id: id,
        userId: user!.id,
        accountId: account!.id,
        categoryId: category,
        amount: amount,
        made: DateTime.now(),
        description: description);

    await database.add('transactions', transaction);
  }

  Future<void> deleteTransaction(WidgetRef ref, String id) async {
    final database = ref.watch(databaseProvider);

    await database.delete('transactions', id);
  }
}
