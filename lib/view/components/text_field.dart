import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({Key? key,
  required this.controller,
    required this.hint,
    required this.obscureText,

  }) : super(key: key);
 final TextEditingController controller;
 final String hint;
 final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.grey[700]),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        ),
        focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
      color: Colors.white
      ),
    ),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[500]
        )
      ),
    );
  }
}
