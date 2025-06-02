import 'package:flutter/material.dart';

class ButtonCust extends StatelessWidget {
  const ButtonCust({this.onPressed, this.text, super.key});
  final Function()? onPressed;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(text ?? "Simpan"));
  }
}
