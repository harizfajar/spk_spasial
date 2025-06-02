import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spk/pages/Kecamatan/notifier/kecamatan_notifier.dart';
import 'package:spk/widgets/notif.dart';
import 'package:spk/widgets/textformfield.dart';

class AddKecamatan extends ConsumerStatefulWidget {
  const AddKecamatan({super.key});

  @override
  ConsumerState<AddKecamatan> createState() => _AddKecamatanState();
}

class _AddKecamatanState extends ConsumerState<AddKecamatan> {
  final namaKacamatanController = TextEditingController();
  final jumlahPendudukController = TextEditingController();
  final kepadatanPendudukController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    namaKacamatanController.dispose();
    jumlahPendudukController.dispose();
    kepadatanPendudukController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kecamatan = ref.watch(kecamatanNotifierProvider);
    final kecamatanNotifier = ref.read(kecamatanNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Kecamatan")),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            spacing: 10,
            children: [
              textformfieldCust(
                controller: namaKacamatanController,
                hintText: "Nama Kecamatan",
                validator:
                    (p0) =>
                        p0!.isEmpty
                            ? "Nama Kecamatan tidak boleh kosong"
                            : null,
              ),
              textformfieldCust(
                controller: jumlahPendudukController,
                keyboardType: TextInputType.number,
                hintText: "Jumlah Penduduk",
                validator:
                    (p0) =>
                        p0!.isEmpty
                            ? "Jumlah Penduduk tidak boleh kosong"
                            : null,
              ),
              textformfieldCust(
                controller: kepadatanPendudukController,
                keyboardType: TextInputType.number,
                hintText: "Kepadatan Penduduk",
                validator:
                    (p0) =>
                        p0!.isEmpty
                            ? "Kepadatan Penduduk tidak boleh kosong"
                            : null,
              ),
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    showErrorSnackBar(context);
                    return;
                  }
                  kecamatanNotifier.addKecamatan(
                    context,
                    nama: namaKacamatanController.text,
                    jumlahPenduduk: int.parse(jumlahPendudukController.text),
                    kepadatanPenduduk: int.parse(
                      kepadatanPendudukController.text,
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  child: const Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
