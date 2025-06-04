import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spk/pages/perhitunganSAW/notifier.dart/perhitunganSAW_notifier.dart';
import 'package:spk/widgets/text.dart';

class PerhituganSAW extends ConsumerWidget {
  const PerhituganSAW({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kecamtan = ref.watch(getKecamatan);
    final kriteria = ref.watch(getKriteria);
    final alternatif = ref.watch(getAlternatif);
    final norm = ref.watch(normalisasi);
    final hasilSaw = ref.watch(hasil);
    return Scaffold(
      appBar: AppBar(title: const Text("Perhitungan SAW")),
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
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
            kriteria.when(
              data: (data) {
                data.sort((a, b) => a.kode!.compareTo(b.kode!));
                return TableCust(
                  data: data,
                  columns: [
                    DataColumn(label: Text("Kode")),
                    DataColumn(label: Text("Kriteria")),
                    DataColumn(label: Text("Jenis")),
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

            alternatif.when(
              data: (data) {
                return TableCust(
                  data: data,
                  columns: [
                    DataColumn(label: Text("Nama Fasilitas")),
                    DataColumn(label: Text("K1"), numeric: true),
                    DataColumn(label: Text("K2"), numeric: true),
                    DataColumn(label: Text("K3"), numeric: true),
                    DataColumn(label: Text("K4"), numeric: true),
                  ],
                  rows:
                      data.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Center(
                                child: Text(
                                  item.nama.toString(),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            DataCell(Text(item.kerusakan.toString())),
                            DataCell(Text(item.jumlahPenduduk.toString())),
                            DataCell(
                              Text("${item.jarak!.toStringAsFixed(2)} km"),
                            ),
                            DataCell(Text(item.kepadatan.toString())),
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
            TextCust(text: "Normalisasi Matriks", fontWeight: FontWeight.bold),
            TextCust(
              text:
                  "Rumus Benefit: value/max(value)\nRumus Cost: min(value)/value\nContoh Benefit: 3/5 = 0.6\nContoh Cost: 0.001/0.12 = 0.01",
              fontWeight: FontWeight.bold,
            ),
            norm.isNotEmpty
                ? TableCust(
                  data: norm,
                  columns: [
                    DataColumn(label: Text("Nama Fasilitas")),
                    DataColumn(label: Text("K1"), numeric: true),
                    DataColumn(label: Text("K2"), numeric: true),
                    DataColumn(label: Text("K3"), numeric: true),
                    DataColumn(label: Text("K4"), numeric: true),
                  ],
                  rows:
                      norm.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Center(child: Text(item['name'].toString())),
                            ),
                            DataCell(
                              Text(item["tingkat_kerusakan"].toString()),
                            ),
                            DataCell(
                              Text(item['jumlah_penduduk'].toStringAsFixed(2)),
                            ),
                            DataCell(
                              Text(item['jarak_ke_istana'].toStringAsFixed(6)),
                            ),
                            DataCell(
                              Text(
                                item["kepadatan_penduduk"].toStringAsFixed(2),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                )
                : CircularProgressIndicator(),

            hasilSaw.isNotEmpty
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextCust(),
                    TableCust(
                      columns: [
                        DataColumn(label: Text("Nama Fasilitas")),
                        DataColumn(label: Text("Skor"), numeric: true),
                      ],
                      rows:
                          hasilSaw.map((item) {
                            return DataRow(
                              cells: [
                                DataCell(Text(item['name'].toString())),
                                DataCell(Text(item['skor'].toStringAsFixed(4))),
                              ],
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Langkah-langkah Perhitungan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...hasilSaw.map((item) {
                      return ExpansionTile(
                        title: Text(
                          "${item['name']} - Skor: ${item['skor'].toStringAsFixed(4)}",
                        ),
                        children:
                            (item['langkah'] as Map<String, dynamic>).entries.map((
                              e,
                            ) {
                              final kode = e.key;
                              final l = e.value;
                              return ListTile(
                                title: Text("Kriteria $kode"),
                                subtitle: Text(
                                  "Normalisasi: ${l['nilai_normalisasi'].toStringAsFixed(4)} × Bobot: ${l['bobot']} = ${l['nilai_x_bobot'].toStringAsFixed(4)}",
                                ),
                              );
                            }).toList(),
                      );
                    }).toList(),
                  ],
                )
                : CircularProgressIndicator(),
          ],
        ),
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
