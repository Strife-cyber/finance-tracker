import 'package:finance_tracker/features/landing/landing_desktop.dart';
import 'package:finance_tracker/features/landing/landing_mobile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 550 && constraints.maxHeight < 1300) {
        return const LandingMobile();
      } else {
        return const LandingDesktop();
      }
    });
  }
}
