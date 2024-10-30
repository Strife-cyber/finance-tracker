import 'package:finance_tracker/currents/category_details.dart';
import 'package:finance_tracker/currents/current_budget.dart';
import 'package:finance_tracker/database/models/budgets.dart';
import 'package:finance_tracker/features/dashboard/cards/build_budget_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BudgetCard extends ConsumerStatefulWidget {
  final String category;
  final Budgets budget;
  final CategoryDetails details;

  const BudgetCard(
      {super.key,
      required this.category,
      required this.budget,
      required this.details});

  @override
  ConsumerState<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends ConsumerState<BudgetCard> {
  @override
  Widget build(BuildContext context) {
    final budgetProvider = ref.watch(currentBudgetProvider);
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(widget.budget.created);

    return GestureDetector(
      onForcePressStart: (details) {
        budgetProvider.deleteBudget(ref, widget.budget.id);
      },
      onTap: () {
        _showFloatingMenu(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.yellowAccent,
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Budget: ${widget.budget.id}",
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87)),
                    Text("Category: ${widget.category}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]))
                  ],
                ),
                const SizedBox(height: 10.0),
                // We will add a budget spending analysis here
                BudgetDetails(details: widget.details),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${widget.budget.amount.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent)),
                    Text(
                      formattedDate,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show a floating menu when the card is tapped
  void _showFloatingMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0), // Adjust position
      items: [
        const PopupMenuItem<String>(
          value: 'update',
          child: Text('Update Amount'),
        ),
      ],
    ).then((value) {
      if (value == 'update') {
        if (ref.context.mounted) {
          _showUpdateAmountDialog(context);
        }
      }
    });
  }

  // Show a dialog to update the budget amount
  void _showUpdateAmountDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Budget Amount'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter new amount"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double? newAmount = double.tryParse(amountController.text);
                if (newAmount != null) {
                  // Update the budget amount
                  ref.read(currentBudgetProvider).updateBudget(
                        ref,
                        widget.budget,
                        newAmount,
                      );
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
