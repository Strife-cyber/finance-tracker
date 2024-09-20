import 'package:finance_tracker/currents/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/text_field.dart';

class LoginMobile extends ConsumerStatefulWidget {
  const LoginMobile({super.key});

  @override
  ConsumerState<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends ConsumerState<LoginMobile> {
  // Controllers for email and password fields
  List<TextEditingController> controllers =
      List.generate(2, (index) => TextEditingController());

  @override
  void dispose() {
    // Properly dispose controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Container(
      color: Colors.teal[100],
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Log In", style: TextStyle(fontSize: 30)),
          const SizedBox(height: 40),
          buildTextField(label: "E-mail", controller: controllers[0]),
          const SizedBox(height: 15),
          buildTextField(
              label: "Password", controller: controllers[1], obscureText: true),
          const SizedBox(height: 35),
          ElevatedButton(
            onPressed: () async {
              // Call the login function with entered email and password
              await currentUser.login(
                controllers[0].text, // email
                controllers[1].text, // password
                ref, // pass WidgetRef
              );
            },
            child: const Text("SUBMIT"),
          ),
        ],
      ),
    );
  }
}
