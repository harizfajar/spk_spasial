import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spk/pages/Kriteria/notifier/Kriteria_notifier.dart';
import 'package:spk/widgets/button.dart';
import 'package:spk/widgets/dropdown.dart';
import 'package:spk/widgets/notif.dart';
import 'package:spk/widgets/textformfield.dart';

class AddKriteria extends ConsumerStatefulWidget {
  const AddKriteria({super.key});

  @override
  ConsumerState<AddKriteria> createState() => _AddKriteriaState();
}

class _AddKriteriaState extends ConsumerState<AddKriteria> {
  final namaKrietriaController = TextEditingController();
  final jenisKriteriaController = TextEditingController();
  final bobotKriteriaController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    namaKrietriaController.dispose();
    jenisKriteriaController.dispose();
    bobotKriteriaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kriteria = ref.watch(kriteriaNotifierProvider);
    final kriteriaNotifier = ref.read(kriteriaNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Kriteria")),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            spacing: 10,
            children: [
              textformfieldCust(
                controller: namaKrietriaController,
                hintText: "Nama Kriteria",
                validator:
                    (p0) =>
                        p0!.isEmpty ? "Nama Kriteria tidak boleh kosong" : null,
              ),
              DropdownbuttonCust(
                hintText: "Jenis Kriteria",
                onChanged: (value) {
                  kriteriaNotifier.setJenisKriteria(value);
                },
                validator: "Jenis Kriteria tidak boleh kosong",
                items:
                    jenisKriteria.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                value: kriteria.jenis,
              ),

              textformfieldCust(
                controller: bobotKriteriaController,
                hintText: "Bobot Kriteria",
                keyboardType: TextInputType.number,
                validator:
                    (p0) =>
                        p0!.isEmpty
                            ? "Bobot Kriteria tidak boleh kosong"
                            : null,
              ),
              ButtonCust(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    showSnackBar(context);
                    return;
                  }
                  kriteriaNotifier.addKriteria(
                    context,
                    namaKriteria: namaKrietriaController.text,
                    jenis: kriteria.jenis,
                    bobot: double.parse(bobotKriteriaController.text),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
