import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:spk/model/fasilitas_model.dart';
import 'package:spk/pages/fasilitasPerbaikan/notifier/perbaikan_notifier.dart';
import 'package:spk/route/route_names.dart';
import 'package:spk/services/haversine_services.dart';
import 'package:spk/widgets/button.dart';
import 'package:spk/widgets/dropdown.dart';
import 'package:spk/widgets/notif.dart';
import 'package:spk/widgets/textformfield.dart';

class AddPerbaikan extends ConsumerStatefulWidget {
  const AddPerbaikan({super.key});

  @override
  ConsumerState<AddPerbaikan> createState() => _AddPerbaikanState();
}

class _AddPerbaikanState extends ConsumerState<AddPerbaikan> {
  final nameFasilitasController = TextEditingController();
  final tingkatKerusakanController = TextEditingController();
  final wargaTerdampakController = TextEditingController();
  final kepadatanController = TextEditingController();
  final lokasiKecamatanController = TextEditingController();
  final biayaController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameFasilitasController.dispose();
    tingkatKerusakanController.dispose();
    wargaTerdampakController.dispose();
    kepadatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fasilitas = ref.watch(perbaikanNotifierProvider);
    final fasilitasNotifier = ref.read(perbaikanNotifierProvider.notifier);
    final bool = ref.watch(boolNotifierProvider);
    final boolN = ref.read(boolNotifierProvider.notifier);
    final IstanaPresiden = ref.watch(istanaPresidenNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Perbaikan")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownbuttonCust(
                  items:
                      namaFasilitas.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                  hintText: "Pilih Fasilitas",
                  onChanged: (value) {
                    fasilitasNotifier.fasilitas(value!);
                  },
                  validator: "Fasilitas tidak boleh kosong",
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
                      border: Border.all(
                        color:
                            bool == true
                                ? Colors.grey
                                : const Color.fromARGB(255, 184, 12, 0),
                      ),
                    ),
                    child: Text(
                      textAlign: TextAlign.start,
                      fasilitas.value!.lokasi != null
                          ? 'Lat: ${fasilitas.value!.lokasi!.latitude.toStringAsFixed(5)}, Lng: ${fasilitas.value!.lokasi!.longitude.toStringAsFixed(5)}'
                          : "Pilih Lokasi",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                bool == false
                    ? Padding(
                      padding: const EdgeInsets.only(left: 12, top: 4),
                      child: Text(
                        "Lokasi belum dipilih",
                        style: TextStyle(
                          color: Color.fromARGB(255, 184, 12, 0),
                          fontSize: 12,
                        ),
                      ),
                    )
                    : SizedBox(),
                SizedBox(height: 8),
                DropdownbuttonCust(
                  onChanged: (p0) => fasilitasNotifier.kerusakan(p0),
                  value: fasilitas.value!.kerusakan,
                ),

                SizedBox(height: 8),

                DropdownSearch<String>(
                  items: (filter, infiniteScrollProps) => namaKecamatan,
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      hintText: "Pilih lokasi kecamatan",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    // Atau .dialog, .bottomSheet
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                        hintText: "Cari kecamatan...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  onChanged: (String? value) {
                    fasilitasNotifier.kecamatan(value!);
                    print("Dipilih: $value");
                  },
                  selectedItem: fasilitas.value!.kecamatan, // Bind ke state
                  validator:
                      (item) =>
                          item == null || item.isEmpty
                              ? "Kecamatan tidak boleh kosong"
                              : null,
                ),

                SizedBox(height: 16),
                Center(
                  child: ButtonCust(
                    text: fasilitas.isLoading ? "Loading..." : "Simpan",
                    onPressed: () {
                      if (fasilitas.value?.lokasi != null) {
                        boolN.setBool(true);
                      } else {
                        boolN.setBool(false);
                      }

                      if (!formKey.currentState!.validate()) {
                        showSnackBar(
                          context,
                          message: "Lengkapi data terlebih dahulu",
                        );
                        return;
                      }

                      fasilitasNotifier.addPerbaikan(context);
                    },
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
