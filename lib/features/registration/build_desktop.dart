// Home Page
// ignore_for_file: use_build_context_synchronously

import 'package:finance_tracker/currents/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Home Page
Widget buildHomePage() {
  return const Center(
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage("assets/icons/nexus.jpeg"),
          ),
          SizedBox(height: 20),
          Text(
            'Welcome to Nexus Finance Tracker!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Keep track of your finances with us! And never lose money again.",
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );
}

// Login Page
Widget buildLoginPage(WidgetRef ref, List<TextEditingController> controllers) {
  final currentUser = ref.watch(currentUserProvider);

  return Center(
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage("assets/icons/nexus.jpeg"),
          ),
          const SizedBox(height: 20),
          const Text(
            'Login',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controllers[0],
            decoration: InputDecoration(
              labelText: 'Username',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controllers[1],
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await currentUser.login(
                  controllers[0].text, controllers[1].text, ref);
            },
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    ),
  );
}

// Sign Up Page
Widget buildSignUpPage(WidgetRef ref, List<TextEditingController> controllers) {
  final currentUser = ref.watch(currentUserProvider);

  return Center(
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage("assets/icons/nexus.jpeg"),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sign Up',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controllers[0],
            decoration: InputDecoration(
              labelText: 'Username',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controllers[1],
            decoration: InputDecoration(
              labelText: 'Email',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controllers[2],
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await currentUser.signUp(controllers[1].text, controllers[0].text,
                  controllers[2].text, ref);
            },
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    ),
  );
}
