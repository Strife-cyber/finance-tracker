// Reusable text field builder for input fields
import 'package:flutter/material.dart';

Widget buildTextField(
    {required String label,
    bool obscureText = false,
    required TextEditingController controller}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      filled: true,
      fillColor: Colors.grey[200],
    ),
  );
}
