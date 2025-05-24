import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spk/pages/addPerbaikan/fasilitas_model.dart';

part 'add_perbaikan_notifier.g.dart';

@riverpod
class PilihLokasiNotifier extends _$PilihLokasiNotifier {
  @override
  LatLng? build() {
    return null; // Nilai awal state = null
  }

  void setLocation(LatLng location) {
    state = location;
  }
}

@riverpod
class AddPerbaikanNotifier extends _$AddPerbaikanNotifier {
  @override
  FasilitasModel build() {
    return FasilitasModel();
  }

  void namaFasilitas(FasilitasModel fasilitas) {
    state = fasilitas.copy(nama: fasilitas.nama);
  }

  void lokasi(FasilitasModel fasilitas) {
    state = fasilitas.copy(lokasi: fasilitas.lokasi);
  }

  void kerusakan(FasilitasModel fasilitas) {
    state = fasilitas.copy(kerusakan: fasilitas.kerusakan);
  }

  void warga(FasilitasModel fasilitas) {
    state = fasilitas.copy(wargaTerdampak: fasilitas.wargaTerdampak);
  }

  void kepadatan(FasilitasModel fasilitas) {
    state = fasilitas.copy(kepadatan: fasilitas.kepadatan);
  }

  void biaya(FasilitasModel fasilitas) {
    state = fasilitas.copy(biaya: fasilitas.biaya);
  }

  void kecamatan(FasilitasModel fasilitas) {
    state = fasilitas.copy(kecamatan: fasilitas.kecamatan);
  }
}

final fasilitasProvider = StreamProvider<List<FasilitasModel>>((ref) {
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
