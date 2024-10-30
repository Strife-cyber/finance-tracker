import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../currents/current_account.dart';

class UpdateAccountMobile extends ConsumerStatefulWidget {
  const UpdateAccountMobile({super.key});

  @override
  ConsumerState<UpdateAccountMobile> createState() =>
      _UpdateAccountMobileState();
}

class _UpdateAccountMobileState extends ConsumerState<UpdateAccountMobile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  Uint8List? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCurrentAccountInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentAccountInfo() async {
    final currentAccount = ref.read(currentAccountProvider);

    // Load the current account info and set it to the controllers
    final account = currentAccount.getAccount();
    setState(() {
      _nameController.text = account!.accounts.name;
      _salaryController.text = account.accounts.salary.toString();
      _image = account.image;
    });
  }

  // Function to pick an image based on platform
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = Uint8List.fromList(await pickedFile.readAsBytes());
        setState(() {});
      }
    } catch (e) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  // Function to update the account information
  Future<void> _updateAccount() async {
    final currentAccount = ref.read(currentAccountProvider);

    final name = _nameController.text;
    final salary = double.tryParse(_salaryController.text);

    if (name.isEmpty || salary == null || salary <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide valid inputs.')),
      );
      return;
    }

    try {
      // Update the image if provided
      if (_image != null) {
        currentAccount.setImage(_image!);
      }

      // Update the account
      await currentAccount.updateAccount(ref, name, salary);

      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text('Account updated successfully.')),
        );
      }
    } catch (e) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(content: Text('Account update failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Update Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Image picker
            GestureDetector(
              onTap: _pickImage,
              child: _image != null
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.camera_alt, size: 40),
                    ),
            ),
            const SizedBox(height: 20),

            // Name input field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Salary input field
            TextField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Salary',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),

            // Update button
            ElevatedButton(
              onPressed: _updateAccount,
              child: const Text('Update Account'),
            ),
          ],
        ),
      ),
    );
  }
}
