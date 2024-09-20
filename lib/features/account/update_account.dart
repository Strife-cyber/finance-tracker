import 'package:finance_tracker/features/account/update_account_desktop.dart';
import 'package:finance_tracker/features/account/update_account_mobile.dart';
import 'package:flutter/material.dart';

class UpdateAccount extends StatelessWidget {
  const UpdateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 550 && constraints.maxHeight < 1300) {
        return const UpdateAccountMobile();
      } else {
        return const AccountUpdateDesktop();
      }
    });
  }
}
