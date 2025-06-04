import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class FasilitasModel {
  final String? id;
  final String? nama;
  final int? kerusakan;
  final String? kecamatan;
  final int? kepadatan;
  final int? jumlahPenduduk;
  final double? jarak;
  final double? skor;
  final int? prioritas;
  final LatLng? lokasi;
  final DateTime? createdAt;

  FasilitasModel({
    this.id,
    this.nama,
    this.kerusakan,
    this.kecamatan,
    this.kepadatan,
    this.jumlahPenduduk,
    this.jarak,
    this.lokasi,
    this.skor,
    this.prioritas,
    this.createdAt,
  });
  FasilitasModel copy({
    final String? id,
    final String? nama,
    final int? kerusakan,
    final String? kecamatan,
    final int? kepadatan,
    final int? jumlahPenduduk,
    final LatLng? lokasi,
    final double? jarak,
    final double? skor,
    final int? prioritas,
    final DateTime? createdAt,
  }) {
    return FasilitasModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kerusakan: kerusakan ?? this.kerusakan,
      kecamatan: kecamatan ?? this.kecamatan,
      kepadatan: kepadatan ?? this.kepadatan,
      jumlahPenduduk: jumlahPenduduk ?? this.jumlahPenduduk,
      jarak: jarak ?? this.jarak,
      lokasi: lokasi ?? this.lokasi,
      skor: skor ?? this.skor,
      prioritas: prioritas ?? this.prioritas,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory FasilitasModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final lokasiMap = map['lokasi'] ?? {};

    return FasilitasModel(
      id: id,
      nama: map['nama_fasilitas'] ?? '',
      kerusakan: map['tingkat_kerusakan'] ?? 0,
      kecamatan: map['lokasi_kecamatan'] ?? '',
      jarak: map['jarak_ke_istana'] ?? 0,
      kepadatan: map['kepadatan_penduduk'] ?? 0,
      jumlahPenduduk: map['jumlah_penduduk'] ?? 0,
      lokasi: LatLng(lokasiMap['lat'] ?? 0.0, lokasiMap['lng'] ?? 0.0),
      createdAt: (map['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  factory FasilitasModel.fromMapLokasi(Map<String, dynamic> map, {String? id}) {
    final lokasiMap = map['lokasi'] ?? {};

    return FasilitasModel(
      nama: map['nama_fasilitas'] ?? '',
      kerusakan: map['tingkat_kerusakan'] ?? 0,
      kecamatan: map['lokasi_kecamatan'],
      jarak: map['jarak_ke_istana'] ?? 0,
      kepadatan: map['kepadatan_penduduk'],
      lokasi: LatLng(
        lokasiMap['latitude'] ?? 0.0,
        lokasiMap['longitude'] ?? 0.0,
      ),
      jumlahPenduduk: map['jumlah_penduduk'],
      createdAt: (map['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
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
