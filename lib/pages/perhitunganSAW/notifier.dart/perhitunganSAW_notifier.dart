import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spk/model/kecamatan_model.dart';
import 'package:spk/model/kriteria_model.dart';

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

final getKriteria = StreamProvider.autoDispose<List<KriteriaModel>>((ref) {
  return FirebaseFirestore.instance
      .collection("kriteria")
      .snapshots()
      .map(
        (s) =>
            s.docs
                .map((doc) => KriteriaModel.fromMap(doc.data(), id: doc.id))
                .toList(),
      );
});
