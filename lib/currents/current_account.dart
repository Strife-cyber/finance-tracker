import 'dart:convert';
import 'dart:typed_data';
import 'package:finance_tracker/currents/current_user.dart';
import 'package:finance_tracker/database/models/accounts.dart';
import 'package:finance_tracker/database/queries/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../features/dashboard/dashboard.dart';

final currentAccountProvider = Provider((ref) => CurrentAccount());

class UserTuple {
  final Uint8List? image;
  final Accounts accounts;

  UserTuple({required this.image, required this.accounts});

  Uint8List? getImageAsBytes() {
    return image;
  }

  Accounts getAccount() {
    return accounts;
  }
}

class CurrentAccount {
  Accounts? accounts;
  Uint8List? image;

  UserTuple? getAccount() {
    if (accounts != null) {
      return UserTuple(image: image, accounts: accounts!);
    } else {
      return null;
    }
  }

  void setAccount(Accounts currentAccount) {
    accounts = currentAccount;
  }

  void setImage(Uint8List currentImage) {
    image = currentImage;
  }

  Future<void> registerAccount(WidgetRef ref, double salary) async {
    final currentUser = ref.watch(currentUserProvider);
    final user = currentUser.getCurrentUser();
    final database = ref.watch(databaseProvider);
    Uuid uuid = const Uuid();
    String id = uuid.v4();

    if (user != null) {
      // Create account for the user
      Accounts register =
          Accounts(id: id, name: user.name, salary: salary, userId: user.id);

      // Store the account in the database
      await database.add('accounts', register);

      // Register the image in SharedPreferences
      if (image != null) {
        await _registerImage(user.id, image!, ref);
      }

      // Set the current account after successful registration
      setAccount(register);
      if (ref.context.mounted) {
        Navigator.pushReplacement(ref.context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      }
    } else {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(
              content: Text("User is not logged in, can't register account")),
        );
      }
    }
  }

  // Helper function to register the image in SharedPreferences
  Future<void> _registerImage(
      String userId, Uint8List imageBytes, WidgetRef ref) async {
    try {
      // Convert image to Base64 string
      String imageBase64 = base64Encode(imageBytes);

      // Store image in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('account_image_$userId', imageBase64);
    } catch (e) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(content: Text('Image registration failed: $e')),
        );
      }
    }
  }

  // Helper function to retrieve the image from SharedPreferences
  Future<Uint8List?> getImage(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imageBase64 = prefs.getString('account_image_$userId');

    if (imageBase64 != null) {
      return base64Decode(imageBase64);
    }

    return null;
  }

  // Function to update the account information
  Future<void> updateAccount(WidgetRef ref, String name, double salary) async {
    final database = ref.watch(databaseProvider);
    final userProvider = ref.watch(currentUserProvider);
    final user = userProvider.getCurrentUser();

    if (accounts != null) {
      // Update the account details in the database
      final updatedAccount = Accounts(
          id: accounts!.id,
          userId: accounts!.userId,
          name: name,
          salary: salary);

      await database.update('accounts', updatedAccount, accounts!.id);

      // Update the current account
      setAccount(updatedAccount);

      // Update the image if provided
      if (image != null) {
        await _registerImage(user!.id, image!, ref);
      }

      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text('Account updated successfully.')),
        );
        Navigator.pushReplacement(ref.context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      }
    } else {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text('No account found to update.')),
        );
      }
    }
  }
}
