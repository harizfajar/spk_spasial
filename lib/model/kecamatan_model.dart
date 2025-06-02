import 'package:cloud_firestore/cloud_firestore.dart';

class KecamatanModel {
  final String? id; // ID dokumen Firestore
  final String? namaKecamatan;
  final int? kepadatanPenduduk;
  final int? jumlahWargaTerdampak;
  final int? jumlahFasilitasRusak;

  KecamatanModel({
    this.id,
    this.namaKecamatan,
    this.kepadatanPenduduk,
    this.jumlahWargaTerdampak,
    this.jumlahFasilitasRusak,
  });

  KecamatanModel copy({
    String? id,
    String? namaKecamatan,
    int? kepadatanPenduduk,
    int? jumlahWargaTerdampak,
    int? jumlahFasilitasRusak,
  }) {
    return KecamatanModel(
      id: id ?? this.id,
      namaKecamatan: namaKecamatan ?? this.namaKecamatan,
      kepadatanPenduduk: kepadatanPenduduk ?? this.kepadatanPenduduk,
      jumlahWargaTerdampak: jumlahWargaTerdampak ?? this.jumlahWargaTerdampak,
      jumlahFasilitasRusak: jumlahFasilitasRusak ?? this.jumlahFasilitasRusak,
    );
  }

  factory KecamatanModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return KecamatanModel(
      id: id,
      namaKecamatan: map['nama'] as String?,
      kepadatanPenduduk: map['kepadatan_penduduk'] as int?,
      jumlahWargaTerdampak: map['jumlah_warga_terdampak'] as int?,
      jumlahFasilitasRusak: map['jumlah_fasilitas_rusak'] as int?,
    );
  }

  factory KecamatanModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw Exception("Data kecamatan kosong untuk dokumen ${doc.id}");
    }
    return KecamatanModel(
      id: doc.id,
      namaKecamatan: data['nama_kecamatan'] as String?,
      kepadatanPenduduk: data['kepadatan_penduduk'] as int?,
      jumlahWargaTerdampak: data['jumlah_warga_terdampak'] as int?,
      jumlahFasilitasRusak: data['jumlah_fasilitas_rusak'] as int?,
    );
  }
}
