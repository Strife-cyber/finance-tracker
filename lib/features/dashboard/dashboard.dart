import 'package:finance_tracker/features/dashboard/desktop_dashboard.dart';
import 'package:finance_tracker/features/dashboard/mobile_dashboard.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxHeight < 1300 && constraints.maxWidth < 550) {
        return const MobileDashboard();
      } else {
        return const DesktopDashboard();
      }
    });
  }
}
