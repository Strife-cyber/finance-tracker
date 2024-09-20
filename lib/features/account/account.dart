import 'package:finance_tracker/features/account/account_desktop.dart';
import 'package:finance_tracker/features/account/account_mobile.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 550 && constraints.maxHeight < 1300) {
        return const AccountMobile();
      } else {
        return const AccountDesktop();
      }
    });
  }
}
