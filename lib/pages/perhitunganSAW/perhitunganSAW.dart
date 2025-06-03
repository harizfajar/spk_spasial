import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spk/pages/perhitunganSAW/notifier.dart/perhitunganSAW_notifier.dart';

class PerhituganSAW extends ConsumerWidget {
  const PerhituganSAW({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kecamtan = ref.watch(getKecamatan);
    final kriteria = ref.watch(getKriteria);
    return Scaffold(
      appBar: AppBar(title: const Text("Perhitungan SAW")),
      body: Column(
        children: [
          kecamtan.when(
            data: (data) {
              return TableCust(data: data);
            },
            error: (error, stackTrace) {
              return Center(child: Text("Error: $error"));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 10),
          kriteria.when(
            data: (data) {
              data.sort((a, b) => a.kode!.compareTo(b.kode!));
              return TableCust(
                data: data,
                columns: [
                  DataColumn(label: Text("Kode")),
                  DataColumn(label: Text("Nama")),
                  DataColumn(label: Text("Kriteria")),
                  DataColumn(label: Text("Bobot"), numeric: true),
                ],
                rows:
                    data.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Center(child: Text("K${item.kode.toString()}")),
                          ),
                          DataCell(Text(item.nama.toString())),
                          DataCell(Text(item.jenis.toString())),
                          DataCell(Text(item.bobot.toString())),
                        ],
                      );
                    }).toList(),
              );
            },
            error: (error, stackTrace) {
              return Center(child: Text("Error: $error"));
            },
            loading: () => Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView TableCust({
    List<dynamic>? data,
    List<DataRow>? rows,
    List<DataColumn>? columns,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: DataTable(
          columnSpacing: 12.0, // Spasi antar kolom lebih kecil
          dataRowMaxHeight: 32.0, // Tinggi baris data lebih kecil
          dataRowMinHeight: 32.0,
          headingRowHeight: 40.0, // Tinggi baris judul
          horizontalMargin: 8.0, // Margin kiri-kanan tabel lebih kecil
          border: TableBorder.all(color: Colors.grey),
          columns:
              columns ??
              [
                DataColumn(label: Text('Kecamatan')),
                DataColumn(label: Text('Warga Terdampak'), numeric: true),
                DataColumn(label: Text('Kepadatan Penduduk'), numeric: true),
              ],
          rows:
              rows ??
              data!.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.namaKecamatan.toString())),
                    DataCell(Text(item.jumlahWargaTerdampak.toString())),
                    DataCell(Text(item.kepadatanPenduduk.toString())),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
