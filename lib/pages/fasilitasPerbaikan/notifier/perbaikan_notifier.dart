import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spk/model/fasilitas_model.dart';
import 'package:spk/services/firebase_services.dart';

part 'perbaikan_notifier.g.dart';

@riverpod
class IstanaPresidenNotifier extends _$IstanaPresidenNotifier {
  @override
  LatLng? build() {
    return LatLng(
      -6.575268332452798,
      106.66082577626865,
    ); // Nilai awal state = null
  }

  void setLocation(LatLng location) {
    state = location;
  }
}

@riverpod
class BoolNotifier extends _$BoolNotifier {
  @override
  bool? build() {
    return true; // Nilai awal state = null
  }

  void setBool(bool newValue) {
    state = newValue;
  }
}

@riverpod
class PerbaikanNotifier extends _$PerbaikanNotifier {
  @override
  FasilitasModel build() {
    return FasilitasModel();
  }

  void lokasi(FasilitasModel fasilitas) {
    state = fasilitas.copy(lokasi: fasilitas.lokasi);
  }

  void setLocation(LatLng location) {
    state = state.copy(lokasi: location);
  }

  void fasilitas(String fasilitas) {
    state = state.copy(nama: fasilitas);
  }

  void kecamatan(String kecamatan) {
    state = state.copy(kecamatan: kecamatan);
  }

  void kerusakan(int kerusakan) {
    state = state.copy(kerusakan: kerusakan);
  }

  void addPerbaikan(
    BuildContext context, {
    String? namaFasilitas,
    int? tingkatKerusakan,
    String? lokasiKecamatan,
    LatLng? lokasi,
    double? jarak,
  }) {
    final firebase = FirebaseServices();
    firebase
        .addPerbaikan(
          namaFasilitas: namaFasilitas,
          tingkatKerusakan: tingkatKerusakan,
          lokasiKecamatan: lokasiKecamatan,
          lokasi: lokasi,
          jarakKeKecamatan: jarak,
        )
        .then((value) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Data berhasil disimpan")));
          context.pop();
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal menyimpan data: $error")),
          );
        });
  }
}

final fasilitasRusakProvider = StreamProvider<List<FasilitasModel>>((ref) {
  return FirebaseFirestore.instance
      .collection("fasilitas_umum")
      .snapshots()
      .map(
        (snapshots) =>
            snapshots.docs
                .map(
                  (doc) => FasilitasModel.fromMapLokasi(doc.data(), id: doc.id),
                )
                .toList(),
      );
});

final List<String> namaKecamatan = [
  "BOGOR SELATAN",
  "BOGOR UTARA",
  "BOGOR TIMUR",
  "BOGOR BARAT",
  "BOGOR TENGAH",
  "TANAH SAREAL",
];

final Map<int, String> tingkatKerusakan = {
  1: "Ringan",
  2: "Sedang",
  3: "Berat",
  4: "Sangat Berat",
  5: "Rusak Total",
};

final List<String> namaFasilitas = [
  "Jalan",
  "Saluran Air",
  "Lampu Penerangan Jalan",
];
