import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spk/pages/addPerbaikan/notifier/add_perbaikan_notifier.dart';
import 'package:spk/route/route_names.dart';
import 'package:spk/services/firebase_services.dart';

class AddPerbaikan extends ConsumerWidget {
  const AddPerbaikan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameFasilitasController = TextEditingController();
    final tingkatKerusakanController = TextEditingController();
    final wargaTerdampakController = TextEditingController();
    final kepadatanController = TextEditingController();
    final lokasiKecamatanController = TextEditingController();
    final biayaController = TextEditingController();
    final lokasi = ref.watch(pilihLokasiNotifierProvider);
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Perbaikan")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              textformfieldCust(
                nameFasilitasController: nameFasilitasController,
                validator:
                    (p0) =>
                        p0!.isEmpty
                            ? "Nama Fasilitas tidak boleh kosong"
                            : null,
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () {
                  context.push(pilihLokasi);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    textAlign: TextAlign.start,
                    lokasi != null
                        ? 'Lat: ${lokasi.latitude.toStringAsFixed(5)}, Lng: ${lokasi.longitude.toStringAsFixed(5)}'
                        : "Pilih Lokasi",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 8),
              textformfieldCust(
                nameFasilitasController: tingkatKerusakanController,
                keyboardType: TextInputType.number,
                hintText: "Tingkat Kerusakan",
                validator:
                    (p0) =>
                        p0!.isEmpty
                            ? "Tingkat Kerusakan tidak boleh kosong"
                            : null,
              ),
              SizedBox(height: 8),
              textformfieldCust(
                nameFasilitasController: wargaTerdampakController,
                keyboardType: TextInputType.number,
                hintText: "Warga Terdampak",
                validator:
                    (p0) =>
                        p0!.isEmpty
                            ? "Warga Terdampak tidak boleh kosong"
                            : null,
              ),
              SizedBox(height: 8),
              textformfieldCust(
                nameFasilitasController: kepadatanController,
                keyboardType: TextInputType.number,
                hintText: "Kepadatan Penduduk",
                validator:
                    (p0) =>
                        p0!.isEmpty
                            ? "Kepadatan Penduduk tidak boleh kosong"
                            : null,
              ),
              SizedBox(height: 8),
              textformfieldCust(
                nameFasilitasController: biayaController,
                keyboardType: TextInputType.number,
                hintText: "Estiamsi Biaya Perbaikan",
                validator:
                    (p0) =>
                        p0!.isEmpty
                            ? "Biaya Perbaikan tidak boleh kosong"
                            : null,
              ),
              SizedBox(height: 8),
              textformfieldCust(
                nameFasilitasController: lokasiKecamatanController,
                hintText: "Lokasi Kecamatan",
                validator:
                    (p0) =>
                        p0!.isEmpty
                            ? "Lokasi Kecamatan tidak boleh kosong"
                            : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Isi semua data dengan benar")),
                    );
                    return;
                  }
                  final firebase = FirebaseServices();
                  firebase
                      .addPerbaikan(
                        namaFasilitas: nameFasilitasController.text,
                        tingkatKerusakan: tingkatKerusakanController.text,
                        wargaTerdampak: wargaTerdampakController.text,
                        kepadatan: kepadatanController.text,
                        lokasiKecamatan: lokasiKecamatanController.text,
                        biaya: biayaController.text,
                        lokasi: lokasi,
                      )
                      .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Data berhasil disimpan")),
                        );
                        context.pop();
                      })
                      .catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Gagal menyimpan data: $error"),
                          ),
                        );
                      });
                },
                child: Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class textformfieldCust extends StatelessWidget {
  const textformfieldCust({
    super.key,
    required this.nameFasilitasController,
    this.hintText,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController nameFasilitasController;
  final String? hintText;
  final TextInputType? keyboardType;
  final Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameFasilitasController,
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
