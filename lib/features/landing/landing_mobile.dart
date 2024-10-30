import 'package:finance_tracker/features/registration/loginmobile.dart';
import 'package:finance_tracker/features/registration/signupmobile.dart';
import 'package:flutter/material.dart';

class LandingMobile extends StatelessWidget {
  const LandingMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.teal, // Replaced teal with blue-grey
        leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/icons/nexus.jpeg')),
        title: const Padding(
          padding: EdgeInsets.only(left: 50.0),
          child: Text(
            'Nexus Finance Tracker',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/images/base.jpg',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover, // Consider BoxFit.cover if it suits better
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    const Center(
                      child: Text(
                        'Keep track of your finances with us',
                        style: TextStyle(
                          color: Colors.black, // Ensure text is visible
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) => const SignupMobile());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Matches app bar
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Sign Up'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) => const LoginMobile());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Log In',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
