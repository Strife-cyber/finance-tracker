import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:finance_tracker/features/account/account.dart';
import 'package:finance_tracker/features/dashboard/dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart'; // Required for mailto links on web

import '../database/models/users.dart';
import '../database/queries/database.dart';

final currentUserProvider = Provider((ref) => CurrentUser());

class CurrentUser {
  Users? user;

  Users? getCurrentUser() {
    return user;
  }

  void setCurrentUser(Users currentUser) {
    user = currentUser;
  }

  // Separate function for email sending
  Future<void> _sendRegistrationEmail(Users user) async {
    const String emailBody =
        'Hello! Thank you for joining us at Nexus using our service Finance Tracker.';
    const String subject = 'Registration Email';
    final List<String> cc = ['Finance-Tracker@Nexus.com'];
    final List<String> bcc = ['Finance-Tracker@Nexus.com'];

    if (kIsWeb) {
      // For web: Use mailto link to open email client
      final Uri mailtoUri = Uri(
        scheme: 'mailto',
        path: user.email,
        query:
            'subject=$subject&body=$emailBody&cc=${cc.join(",")}&bcc=${bcc.join(",")}',
      );

      if (await canLaunchUrl(mailtoUri)) {
        await launchUrl(mailtoUri);
      } else {
        if (kDebugMode) {
          print('Could not launch email client');
        }
      }
    } else {
      // For native platforms: Use flutter_email_sender
      final Email email = Email(
        body: emailBody,
        subject: subject,
        recipients: [user.email],
        cc: cc,
        bcc: bcc,
        isHTML: false,
      );

      try {
        await FlutterEmailSender.send(email);
      } catch (e) {
        if (kDebugMode) {
          print('Error Sending email: $e');
        }
      }
    }
  }

  // Sign-up logic
  Future<void> signUp(
      String email, String name, String password, WidgetRef ref) async {
    Uuid uuid = const Uuid();
    String id = uuid.v4();
    final database = ref.watch(databaseProvider);

    try {
      // Hash the password
      final bytes = utf8.encode(password);
      final hashedPassword = sha256.convert(bytes).toString();

      Users user =
          Users(id: id, email: email, name: name, password: hashedPassword);
      await database.add('users', user);
      setCurrentUser(user);

      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text('Sign-up successful!')),
        );

        // Navigate to Account page
        Navigator.pushReplacement(ref.context,
            MaterialPageRoute(builder: (context) => const Account()));

        // Send the registration email
        await _sendRegistrationEmail(user);
      }
    } catch (e) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(content: Text('Sign-up failed: $e')),
        );
      }
    }
  }

  // Login logic
  Future<void> login(String email, String password, WidgetRef ref) async {
    final database = ref.watch(databaseProvider);
    final allUsers = await database.get('users');

    // Hash the password before comparing
    final bytes = utf8.encode(password);
    final hashedPassword = sha256.convert(bytes).toString();

    bool foundUser = false;
    for (var user in allUsers) {
      if (kDebugMode) {
        print(hashedPassword);
      }
      if (user['email'] == email && user['password'] == hashedPassword) {
        setCurrentUser(Users.fromMap(user));
        foundUser = true;
        if (ref.context.mounted) {
          ScaffoldMessenger.of(ref.context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );

          // Navigate to Dashboard page
          Navigator.pushReplacement(ref.context,
              MaterialPageRoute(builder: (context) => const Dashboard()));
        }
        break;
      }
    }
    if (!foundUser && ref.context.mounted) {
      ScaffoldMessenger.of(ref.context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
      if (kDebugMode) {
        print("User Not Found");
      }
    }
  }
}
