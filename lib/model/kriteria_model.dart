import 'package:cloud_firestore/cloud_firestore.dart';

class KriteriaModel {
  String? kode;
  String? nama;
  String? bobot;
  String? jenis;

  KriteriaModel({this.kode, this.nama, this.bobot, this.jenis});

  KriteriaModel copy({
    String? kode,
    String? nama,
    String? bobot,
    String? jenis,
  }) {
    return KriteriaModel(
      kode: kode ?? this.kode,
      nama: nama ?? this.nama,
      bobot: bobot ?? this.bobot,
      jenis: jenis ?? this.jenis,
    );
  }

  KriteriaModel FromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception("Data kriteria kosong untuk dokumen ${doc.id}");
    }
    return KriteriaModel(
      kode: data['kode'] as String?,
      nama: data['nama'] as String?,
      bobot: data['bobot'] as String?,
      jenis: data['jenis'] as String?,
    );
  }
}
