import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spk/model/kecamatan_model.dart';
import 'package:spk/services/firebase_services.dart';
part 'kecamatan_notifier.g.dart';

final firebase = FirebaseServices();

@riverpod
class KecamatanNotifier extends _$KecamatanNotifier {
  @override
  KecamatanModel build() {
    return KecamatanModel();
  }

  void addKecamatan(
    BuildContext context, {
    String? nama,
    int? jumlahPenduduk,
    int? kepadatanPenduduk,
  }) async {
    firebase
        .addKecamatan(
          nama: nama,
          jumlahPenduduk: jumlahPenduduk,
          kepadatanPenduduk: kepadatanPenduduk,
        )
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kecamatan berhasil ditambahkan')),
          );
          context.pop();
        })
        .catchError((error) {
          print("ERROR ADD KRITERIA $error");
          throw Exception('Gagal menyimpan data: $error');
        });
  }
}
