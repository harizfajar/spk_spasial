import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spk/model/fasilitas_model.dart';
import 'package:spk/model/kecamatan_model.dart';
import 'package:spk/model/kriteria_model.dart';
import 'package:spk/services/SAW_services.dart';

final getKecamatan = StreamProvider.autoDispose<List<KecamatanModel>>((ref) {
  return FirebaseFirestore.instance
      .collection("kecamatan")
      .snapshots()
      .map(
        (s) =>
            s.docs
                .map((doc) => KecamatanModel.fromMap(doc.data(), id: doc.id))
                .toList(),
      );
});

// final getKriteria = StreamProvider.autoDispose<List<KriteriaModel>>((ref) {
//   return FirebaseFirestore.instance
//       .collection("kriteria")
//       .snapshots()
//       .map(
//         (s) =>
//             s.docs
//                 .map((doc) => KriteriaModel.fromMap(doc.data(), id: doc.id))
//                 .toList(),
//       );
// });
final getKriteria = StreamProvider.autoDispose<List<KriteriaModel>>((ref) {
  final data = FirebaseFirestore.instance
      .collection("kriteria")
      .withConverter(
        fromFirestore: (s, _) => KriteriaModel.fromMap(s.data()!, id: s.id),
        toFirestore: (m, _) => m.toMap(),
      );
  return data.snapshots().map((s) => s.docs.map((doc) => doc.data()).toList());
});

final getAlternatif = StreamProvider.autoDispose<List<FasilitasModel>>((ref) {
  final data = FirebaseFirestore.instance
      .collection("fasilitas_umum")
      .withConverter(
        fromFirestore:
            (snap, _) => FasilitasModel.fromMap(snap.data()!, id: snap.id),
        toFirestore: (model, _) => model.toMap(),
      );
  return data.snapshots().map((s) => s.docs.map((doc) => doc.data()).toList());
});

final normalisasi = Provider<List<Map<String, dynamic>>>((ref) {
  final alternatifAsync = ref.watch(getAlternatif);
  final kriteriaAsync = ref.watch(getKriteria);

  if (alternatifAsync is! AsyncData || kriteriaAsync is! AsyncData) return [];
  final kriteriaList = kriteriaAsync.value!;
  final alternatifList = alternatifAsync.value!;
  // Map dari kode kriteria ke field di alternatif
  final fieldMapping = {
    1: 'tingkat_kerusakan',
    2: 'jumlah_penduduk',
    3: 'jarak_ke_istana',
    4: 'kepadatan_penduduk',
  };

  // Ubah kriteria menjadi Map sesuai struktur SAW
  final kriteria =
      kriteriaList.map((item) {
        final kodeField = fieldMapping[item.kode]!;
        return {
          'kode': kodeField,
          'type': item.jenis, // "benefit" atau "cost"
          'bobot': item.bobot,
        };
      }).toList();

  // Ubah alternatif (FasilitasModel) ke List<Map<String, dynamic>>
  final data =
      alternatifList.map((item) {
        return {
          'id': item.id,
          'nama_fasilitas': item.nama,
          'tingkat_kerusakan': item.kerusakan,
          'jumlah_penduduk': item.jumlahPenduduk,
          'kepadatan_penduduk': item.kepadatan,
          'jarak_ke_istana': item.jarak,
        };
      }).toList();

  return SAWServices().normalisasiData(data: data, kriteria: kriteria);
});

final hasil = Provider<List<Map<String, dynamic>>>((ref) {
  final alternatifAsync = ref.watch(getAlternatif);
  final kriteriaAsync = ref.watch(getKriteria);

  if (kriteriaAsync is! AsyncData || alternatifAsync is! AsyncData) return [];
  final kriteriaList = kriteriaAsync.value!;
  final alternatifList = alternatifAsync.value!;

  // Map dari kode kriteria ke field di alternatif
  final fieldMapping = {
    1: 'tingkat_kerusakan',
    2: 'jumlah_penduduk',
    3: 'jarak_ke_istana',
    4: 'kepadatan_penduduk',
  };

  // Ubah kriteria menjadi Map sesuai struktur SAW
  final kriteria =
      kriteriaList.map((item) {
        final kodeField = fieldMapping[item.kode]!;
        return {
          'kode': kodeField,
          'type': item.jenis, // "benefit" atau "cost"
          'bobot': item.bobot,
        };
      }).toList();

  // Ubah alternatif (FasilitasModel) ke List<Map<String, dynamic>>
  final data =
      alternatifList.map((item) {
        return {
          'id': item.id,
          'nama_fasilitas': item.nama,
          'tingkat_kerusakan': item.kerusakan,
          'jumlah_penduduk': item.jumlahPenduduk,
          'kepadatan_penduduk': item.kepadatan,
          'jarak_ke_istana': item.jarak,
        };
      }).toList();

  return SAWServices().getSkor(data: data, kriteria: kriteria);
});
