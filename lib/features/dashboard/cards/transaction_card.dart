import 'package:finance_tracker/currents/current_transaction.dart';
import 'package:finance_tracker/database/models/transactions.dart';
import 'package:finance_tracker/features/dashboard/dashboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends ConsumerWidget {
  final Transactions transaction;
  final String category;
  const TransactionCard(
      {super.key, required this.transaction, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionProvider = ref.watch(currentTransactionProvider);
    String formattedDate = DateFormat('yyyy-MM-dd').format(transaction.made);
    return GestureDetector(
      onDoubleTap: () async {
        transactionProvider.deleteTransaction(ref, transaction.id);
        if (ref.context.mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Dashboard()));
        }
      },
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.yellowAccent,
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Transaction: ${transaction.id}",
                      style: const TextStyle(
                          fontSize: 16.0, color: Colors.black87)),
                  Text(
                    "Category: $category",
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Text(
                transaction.description,
                style: const TextStyle(fontSize: 14.0, color: Colors.black),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\$${transaction.amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent)),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
