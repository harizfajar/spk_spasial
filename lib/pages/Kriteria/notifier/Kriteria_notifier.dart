import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spk/model/kriteria_model.dart';
import 'package:spk/services/firebase_services.dart';
part 'Kriteria_notifier.g.dart';

final firebase = FirebaseServices();

@riverpod
class KriteriaNotifier extends _$KriteriaNotifier {
  @override
  KriteriaModel build() {
    return KriteriaModel();
  }

  void setJenisKriteria(String jenis) {
    state = state.copy(jenis: jenis);
  }

  void addKriteria(
    BuildContext context, {
    String? namaKriteria,
    double? bobot,
    String? jenis,
  }) async {
    firebase
        .addKriteria(nama: namaKriteria, jenis: jenis, bobot: bobot)
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kriteria berhasil ditambahkan')),
          );
          context.pop();
        })
        .catchError((error) {
          print("ERROR ADD KRITERIA $error");
          throw Exception('Gagal menyimpan data: $error');
        });
  }
}

final jenisKriteria = ["Benefit", "Cost"];
