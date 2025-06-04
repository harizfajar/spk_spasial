import 'package:flutter/material.dart';

class SAWServices {
  // Fungsi normalisasi data dengan kriteria dinamis
  List<Map<String, dynamic>> normalisasiData({
    required List<Map<String, dynamic>> data,
    required List<Map<String, dynamic>> kriteria,
  }) {
    final Map<String, double> maxValues = {};
    final Map<String, double> minValues = {};

    for (var k in kriteria) {
      final key = k['kode'];
      final values = data.map((d) => (d[key] as num).toDouble());
      maxValues[key] = values.reduce((a, b) => a > b ? a : b);
      minValues[key] = values.reduce((a, b) => a < b ? a : b);
    }

    return data.map((d) {
      final normalized = <String, dynamic>{
        'id': d['id'],
        'name': d['nama_fasilitas'],
      };

      for (var k in kriteria) {
        final kode = k['kode'];
        final type = k["type"].toLowerCase();
        final value = (d[kode] as num).toDouble();
        if (type == 'benefit') {
          normalized[kode] = value / maxValues[kode]!;
        } else {
          normalized[kode] = minValues[kode]! / value;
        }
      }
      debugPrint("$normalized");
      return normalized;
    }).toList();
  }

  List<Map<String, dynamic>> getSkor({
    required List<Map<String, dynamic>> data,
    required List<Map<String, dynamic>> kriteria,
  }) {
    final normalized = normalisasiData(data: data, kriteria: kriteria);

    final result =
        normalized.map((d) {
          double skor = 0;
          final langkah = <String, dynamic>{};

          for (var k in kriteria) {
            final kode = k['kode'];
            final bobot = (k['bobot'] as num).toDouble();
            final nilai = (d[kode] as num).toDouble();
            final hasilKali = nilai * bobot;
            langkah[kode] = {
              'nilai_normalisasi': nilai,
              'bobot': bobot,
              'nilai_x_bobot': hasilKali,
            };
            skor += hasilKali;
          }

          return {
            'id': d['id'],
            'name': d['name'],
            'skor': skor,
            'langkah': langkah,
          };
        }).toList();

    result.sort((a, b) => b['skor'].compareTo(a['skor']));
    return result.toList();
  }
}
