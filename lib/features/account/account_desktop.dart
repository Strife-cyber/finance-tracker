import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../currents/current_account.dart';

class AccountDesktop extends ConsumerStatefulWidget {
  const AccountDesktop({super.key});

  @override
  ConsumerState<AccountDesktop> createState() => _AccountDesktopState();
}

class _AccountDesktopState extends ConsumerState<AccountDesktop> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  Uint8List? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  // Function to pick an image
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

  // Function to register the account
  Future<void> _registerAccount() async {
    final currentAccount = ref.read(currentAccountProvider);

    final name = _nameController.text;
    final salary = double.tryParse(_salaryController.text);

    if (name.isEmpty || salary == null || salary <= 0) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text('Please provide valid inputs.')),
        );
      }
      return;
    }

    try {
      // Set the image if provided
      if (_image != null) {
        currentAccount.setImage(_image!);
      }

      // Register the account
      await currentAccount.registerAccount(ref, salary);

      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text('Account registered successfully.')),
        );
      }
    } catch (e) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(content: Text('Account registration failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints:
                const BoxConstraints(maxWidth: 1200), // Limit container width
            child: Row(
              children: [
                // Left side: Form fields
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Register Account',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),

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

                      // Register button
                      ElevatedButton(
                        onPressed: _registerAccount,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Register Account'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    width: 40), // Space between form and image preview

                // Right side: Image picker and preview
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const Text(
                        'Account Image',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      // Image picker
                      GestureDetector(
                        onTap: _pickImage,
                        child: _image != null
                            ? CircleAvatar(
                                radius: 80,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.camera_alt, size: 50),
                              ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Click to upload image',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
