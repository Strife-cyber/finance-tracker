import 'package:finance_tracker/database/models/budgets.dart';
import 'package:finance_tracker/database/models/categories.dart';
import 'package:finance_tracker/database/models/transactions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryDetails {
  final Categories categories;
  final List<Transactions> transactionList;
  final Budgets budgets;

  CategoryDetails(
      {required this.categories,
      required this.transactionList,
      required this.budgets});

  double getSpent() {
    double spent = 0;

    for (var transaction in transactionList) {
      spent += transaction.amount;
    }

    return spent;
  }

  double getLeft() {
    return budgets.amount - getSpent();
  }

  Map<String, double> calculateDailySpending() {
    Map<String, double> dailySpending = {};

    for (var transaction in transactionList) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(transaction.made);

      if (dailySpending.containsKey(formattedDate)) {
        dailySpending[formattedDate] =
            dailySpending[formattedDate]! + transaction.amount;
      } else {
        dailySpending[formattedDate] = transaction.amount;
      }
    }

    return dailySpending;
  }

  List<FlSpot> getSpots(Map<String, double> dailySpending) {
    List<FlSpot> spots = [];
    int dayIndex = 0;

    dailySpending.forEach((date, amount) {
      spots.add(FlSpot(dayIndex.toDouble(), amount));
      dayIndex++;
    });

    return spots;
  }

  Widget drawPieChart() {
    var value = ((budgets.amount - getSpent()) / budgets.amount) * 100;
    List<PieChartSectionData> sectionData = [
      PieChartSectionData(
        color: Colors.grey,
        value: value,
        title: 'Left $value%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red[300],
        value: 100 - value,
        title: 'Spent ${100 - value}%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0), // Reduced padding for more space
      child: SizedBox(
        height: 200, // Increased height for better visibility
        child: PieChart(
          PieChartData(
              sections: sectionData,
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 50,
              sectionsSpace: 2,
              centerSpaceColor: Colors.grey[150]),
        ),
      ),
    );
  }

  Widget drawLineChart() {
    Map<String, double> dailySpending = calculateDailySpending();
    List<FlSpot> spots = getSpots(dailySpending);

    return Padding(
      padding: const EdgeInsets.all(16.0), // Reduced padding for more space
      child: SizedBox(
        height: 200, // Increased height for better visibility
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('${(value + 1).toInt()}',
                          style: const TextStyle(fontSize: 10)),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20,
                  getTitlesWidget: (value, meta) {
                    return Text('\$${value.toInt()}');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                dotData: const FlDotData(show: false),
                barWidth: 3,
                color: Colors.blue, // Add color for better visibility
              ),
            ],
            minX: 0,
            maxX: dailySpending.length.toDouble() - 1,
            minY: 0,
            maxY: dailySpending.values.isNotEmpty
                ? dailySpending.values.reduce((a, b) => a > b ? a : b) + 20
                : 150, // Dynamic max Y value
          ),
        ),
      ),
    );
  }
}
