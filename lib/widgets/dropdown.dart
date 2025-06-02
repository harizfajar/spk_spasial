import 'package:flutter/material.dart';
import 'package:spk/pages/fasilitasPerbaikan/notifier/perbaikan_notifier.dart';

class DropdownbuttonCust extends StatelessWidget {
  const DropdownbuttonCust({
    super.key,
    this.items,
    this.hintText,
    this.validator,
    this.onChanged,
    this.value,
  });

  final List<DropdownMenuItem<dynamic>>? items;
  final String? hintText;
  final String? validator;
  final void Function(dynamic)? onChanged;
  final dynamic value;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<dynamic>(
      value: value,
      items:
          items ??
          tingkatKerusakan.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText ?? "Pilih Tingkat Kerusakan",
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
      validator:
          (value) =>
              value == null
                  ? validator ?? "Tingkat kerusakan tidak boleh kosong"
                  : null,
    );
  }
}


