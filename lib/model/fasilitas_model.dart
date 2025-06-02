import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class FasilitasModel {
  final String? id;
  final String? nama;
  final int? kerusakan;
  final String? kecamatan;
  final LatLng? lokasi;
  final DateTime? createdAt;

  FasilitasModel({
    this.id,
    this.nama,
    this.kerusakan,
    this.kecamatan,
    this.lokasi,
    this.createdAt,
  });
  FasilitasModel copy({
    final String? id,
    final String? nama,
    final int? kerusakan,
    final String? kecamatan,
    final LatLng? lokasi,
    final DateTime? createdAt,
  }) {
    return FasilitasModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kerusakan: kerusakan ?? this.kerusakan,
      kecamatan: kecamatan ?? this.kecamatan,
      lokasi: lokasi ?? this.lokasi,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory FasilitasModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final lokasiMap = map['lokasi'] ?? {};

    return FasilitasModel(
      id: id,
      nama: map['nama'] ?? '',
      kerusakan: map['kerusakan'] ?? 0,
      kecamatan: map['kecamatan'] ?? '',
      lokasi: LatLng(lokasiMap['lat'] ?? 0.0, lokasiMap['lng'] ?? 0.0),
      createdAt: (map['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  factory FasilitasModel.fromMapLokasi(Map<String, dynamic> map, {String? id}) {
    final lokasiMap = map['lokasi'] ?? {};

    return FasilitasModel(
      nama: map['nama_fasilitas'] ?? '',
      lokasi: LatLng(
        lokasiMap['latitude'] ?? 0.0,
        lokasiMap['longitude'] ?? 0.0,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'kerusakan': kerusakan,
      'kecamatan': kecamatan,
      'lokasi': {'lat': lokasi!.latitude, 'lng': lokasi!.longitude},
      'created_at': Timestamp.now(),
    };
  }
}
