import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class FasilitasModel {
  final String? id;
  final String? nama;
  final int? kerusakan;
  final int? wargaTerdampak;
  final int? biaya;
  final int? kepadatan;
  final String? kecamatan;
  final LatLng? lokasi;
  final DateTime? createdAt;

  FasilitasModel({
    this.id,
    this.nama,
    this.kerusakan,
    this.wargaTerdampak,
    this.biaya,
    this.kepadatan,
    this.kecamatan,
    this.lokasi,
    this.createdAt,
  });
  FasilitasModel copy({
    final String? id,
    final String? nama,
    final int? kerusakan,
    final int? wargaTerdampak,
    final int? biaya,
    final int? kepadatan,
    final String? kecamatan,
    final LatLng? lokasi,
    final DateTime? createdAt,
  }) {
    return FasilitasModel(
      id: id,
      nama: nama,
      kerusakan: kerusakan,
      wargaTerdampak: wargaTerdampak,
      biaya: biaya,
      kepadatan: kepadatan,
      kecamatan: kecamatan,
      lokasi: lokasi,
      createdAt: createdAt,
    );
  }

  factory FasilitasModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final lokasiMap = map['lokasi'] ?? {};

    return FasilitasModel(
      id: id,
      nama: map['nama'] ?? '',
      kerusakan: map['kerusakan'] ?? 0,
      wargaTerdampak: map['warga_terdampak'] ?? 0,
      kepadatan: map['kepadatan'] ?? 0,
      kecamatan: map['kecamatan'] ?? '',
      lokasi: LatLng(lokasiMap['lat'] ?? 0.0, lokasiMap['lng'] ?? 0.0),
      createdAt: (map['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  factory FasilitasModel.fromMapLokasi(Map<String, dynamic> map, {String? id}) {
    final lokasiMap = map['lokasi'] ?? {};

    return FasilitasModel(
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
      'warga_terdampak': wargaTerdampak,
      'kepadatan': kepadatan,
      'kecamatan': kecamatan,
      'lokasi': {'lat': lokasi!.latitude, 'lng': lokasi!.longitude},
      'created_at': Timestamp.now(),
    };
  }
}
