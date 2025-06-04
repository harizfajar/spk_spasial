import 'package:flutter/material.dart';

class TextCust extends StatelessWidget {
  const TextCust({super.key, this.text, this.fontWeight, this.fontSize});
  final String? text;
  final FontWeight? fontWeight;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "Hasil Perhitungan SAW",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
    );
  }
}
