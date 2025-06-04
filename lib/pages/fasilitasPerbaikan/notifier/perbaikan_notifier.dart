import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spk/model/fasilitas_model.dart';
import 'package:spk/services/firebase_services.dart';
import 'package:spk/services/haversine_services.dart';
import 'package:spk/widgets/notif.dart';

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

final firebase = FirebaseServices();

@riverpod
class PerbaikanNotifier extends _$PerbaikanNotifier {
  @override
  FutureOr<FasilitasModel> build() {
    return FasilitasModel();
  }

  void setLocation(LatLng location) {
    final current = state.value ?? FasilitasModel();
    state = AsyncData(current.copy(lokasi: location));
  }

  void fasilitas(String fasilitas) {
    final current = state.value ?? FasilitasModel();
    state = AsyncData(current.copy(nama: fasilitas));
  }

  void kecamatan(String value) {
    final current = state.value ?? FasilitasModel();
    state = AsyncData(current.copy(kecamatan: value));
  }

  void kerusakan(int value) {
    final current = state.value ?? FasilitasModel();
    state = AsyncData(current.copy(kerusakan: value));
  }

  Future<void> addPerbaikan(BuildContext context) async {
    final IstanaPresiden = ref.watch(istanaPresidenNotifierProvider);

    final current = state.value;
    final jarak = hitungJarak(
      current!.lokasi!.latitude,
      current.lokasi!.longitude,
      IstanaPresiden!.latitude,
      IstanaPresiden.longitude,
    );
    final nama = current.nama;
    final kecamatan = current.kecamatan;
    final kerusakan = current.kerusakan;
    final lokasi = current.lokasi;
    state = const AsyncLoading(); // Tunjukkan loading
    debugPrint("kecamatan $kecamatan");
    try {
      final kecamatanSnap =
          await FirebaseFirestore.instance
              .collection("kecamatan")
              .where("nama", isEqualTo: kecamatan)
              .limit(1)
              .get();

      if (kecamatanSnap.docs.isEmpty) {
        throw Exception("Data kecamatan tidak ditemukan");
      }

      final kecamatanData = kecamatanSnap.docs.first.data();
      final jumlahWarga = kecamatanData["jumlah_warga_terdampak"];
      final kepadatanPenduduk = kecamatanData["kepadatan_penduduk"];

      await firebase.addPerbaikan(
        namaFasilitas: nama,
        tingkatKerusakan: kerusakan,
        lokasiKecamatan: kecamatan,
        kepadatan: kepadatanPenduduk,
        jumlahPenduduk: jumlahWarga,
        lokasi: lokasi,
        jarakKeIstana: jarak,
      );

      state = AsyncData(FasilitasModel()); // Reset state setelah submit
      showSnackBar(context, message: "Data berhasil disimpan");
      context.pop();
    } catch (e, st) {
      state = AsyncError(e, st);
      debugPrint("Gagal menyimpan data: $e");
      showSnackBar(context, message: "Data gagal disimpan $e");
    }
  }

  void deletePerbaikan(BuildContext context, String? id) {
    firebase
        .deletePerbaikan(id: id)
        .then((_) {
          showSnackBar(context, message: "Data berhasil dihapus");
        })
        .catchError((error) {
          debugPrint("error: $error");
          showSnackBar(context, message: "Gagal menghapus data: $error");
        });
  }
}

final List<String> namaKecamatan = [
  "Bogor Selatan",
  "Bogor Utara",
  "Bogor Timur",
  "Bogor Barat",
  "Bogor Tengah",
  "Tanah Sereal",
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
