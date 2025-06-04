import 'package:cloud_firestore/cloud_firestore.dart';

class KriteriaModel {
  int? kode;
  String? nama;
  double? bobot;
  String? jenis;
  String? id; // ID dokumen Firestore, tidak perlu disalin

  KriteriaModel({this.kode, this.nama, this.bobot, this.jenis, this.id});

  KriteriaModel copy({
    int? kode,
    String? nama,
    double? bobot,
    String? jenis,
    String? id,
  }) {
    return KriteriaModel(
      kode: kode ?? this.kode,
      nama: nama ?? this.nama,
      bobot: bobot ?? this.bobot,
      jenis: jenis ?? this.jenis,
      id: id ?? this.id, // ID tidak perlu disalin karena bukan field Firestore
    );
  }

  factory KriteriaModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return KriteriaModel(
      id: id,
      kode: map['kode'] as int?,
      nama: map['nama'] as String?,
      bobot: map['bobot'] as double?,
      jenis: map['jenis'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'kode': kode, 'nama': nama, 'bobot': bobot, 'jenis': jenis};
  }

  factory KriteriaModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw Exception("Data kriteria kosong untuk dokumen ${doc.id}");
    }
    return KriteriaModel(
      kode: data['kode'] as int?,
      nama: data['nama'] as String?,
      bobot: data['bobot'] as double?,
      jenis: data['jenis'] as String?,
    );
  }
}
