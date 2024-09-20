import 'package:finance_tracker/currents/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/text_field.dart';

class SignupMobile extends ConsumerStatefulWidget {
  const SignupMobile({super.key});

  @override
  ConsumerState<SignupMobile> createState() => _SignupMobileState();
}

class _SignupMobileState extends ConsumerState<SignupMobile> {
  // TextEditingControllers for e-mail, username, and password fields
  List<TextEditingController> controllers =
      List.generate(3, (index) => TextEditingController());

  @override
  void dispose() {
    // Dispose of TextEditingControllers properly
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose(); // Call this after disposing of controllers
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
          const Text("Sign Up", style: TextStyle(fontSize: 30)),
          const SizedBox(height: 40),
          buildTextField(label: "E-mail", controller: controllers[0]),
          const SizedBox(height: 15),
          buildTextField(label: "Username", controller: controllers[1]),
          const SizedBox(height: 15),
          buildTextField(
              label: "Password", controller: controllers[2], obscureText: true),
          const SizedBox(height: 35),
          ElevatedButton(
            onPressed: () async {
              // Call the signup function with entered values
              await currentUser.signUp(
                controllers[0].text, // email
                controllers[1].text, // username
                controllers[2].text, // password
                ref, // pass the WidgetRef
              );
            },
            child: const Text("SUBMIT"),
          ),
        ],
      ),
    );
  }
}
