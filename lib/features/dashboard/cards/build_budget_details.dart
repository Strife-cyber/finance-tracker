import 'package:flutter/material.dart';
import 'package:finance_tracker/currents/category_details.dart';

class BudgetDetails extends StatefulWidget {
  final CategoryDetails details;

  const BudgetDetails({super.key, required this.details});

  @override
  State<BudgetDetails> createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> {
  double _slideOffset = 0.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _slideOffset += details.delta.dx; // Update the slide offset
    });
  }

  void _onHorizontalDragEnd(DragEndDetails dragDetails) {
    if (dragDetails.primaryVelocity != null) {
      if (dragDetails.primaryVelocity! < 0) {
        // Swipe left to right (change the displayed chart)
        setState(() {
          _slideOffset =
              -MediaQuery.of(context).size.width; // Slide out to the left
        });
      } else if (dragDetails.primaryVelocity! > 0) {
        // Swipe right to left (reset or go back)
        setState(() {
          _slideOffset = 0.0; // Reset to original position
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(_slideOffset, 0),
            child: widget.details.drawPieChart(),
          ),
          // You can add another chart or widget here that changes
          Transform.translate(
            offset: Offset(_slideOffset + MediaQuery.of(context).size.width, 0),
            child: widget.details.drawLineChart(),
          ),
        ],
      ),
    );
  }
}
