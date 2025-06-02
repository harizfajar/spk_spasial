import 'package:flutter/material.dart';

class textformfieldCust extends StatelessWidget {
  const textformfieldCust({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      validator: validator as FormFieldValidator<String>?,
      decoration: InputDecoration(
        hintText: hintText ?? "Nama Fasilitas",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
