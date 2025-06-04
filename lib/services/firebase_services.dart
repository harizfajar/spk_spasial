import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:spk/model/kecamatan_model.dart';

class FirebaseServices {
  final db = FirebaseFirestore.instance;

  Future<void> addPerbaikan({
    String? namaFasilitas,
    int? tingkatKerusakan,
    String? lokasiKecamatan,
    int? jumlahPenduduk,
    int? kepadatan,
    double? jarakKeIstana,
    LatLng? lokasi,
  }) async {
    try {
      await db.collection("fasilitas_umum").add({
        "nama_fasilitas": namaFasilitas,
        "tingkat_kerusakan": tingkatKerusakan,
        "jumlah_penduduk": jumlahPenduduk,
        "kepadatan_penduduk": kepadatan,
        "lokasi_kecamatan": lokasiKecamatan,
        "prioritas": 0, // Default priority
        "jarak_ke_istana": jarakKeIstana,
        "skor_saw": 0, // Default score
        "lokasi": {
          "latitude": lokasi?.latitude,
          "longitude": lokasi?.longitude,
        },
        "created_at": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("ERROR ADD FASILITAS $e");
      throw Exception('Gagal menyimpan data: $e');
    }
  }

  Future<void> updatePerbaikan({
    String? namaFasilitas,
    int? tingkatKerusakan,
    String? lokasiKecamatan,
    int? jumlahPenduduk,
    int? kepadatan,
    double? jarakKeIstana,
    LatLng? lokasi,
    String? id,
  }) async {
    db
        .collection("fasilitas_umum")
        .doc(id)
        .update({
          "nama_fasilitas": namaFasilitas,
          "tingkat_kerusakan": tingkatKerusakan,
          "jumlah_penduduk": jumlahPenduduk,
          "kepadatan_penduduk": kepadatan,
          "lokasi_kecamatan": lokasiKecamatan,
          "prioritas": 0, // Default priority
          "jarak_ke_istana": jarakKeIstana,
          "skor_saw": 0, // Default score
          "lokasi": {
            "latitude": lokasi?.latitude,
            "longitude": lokasi?.longitude,
          },
          "created_at": FieldValue.serverTimestamp(),
        })
        .then((value) {
          debugPrint("Data berhasil diubah");
        })
        .catchError((error) {
          debugPrint("error $error");
          throw Exception('Gagal menyimpan data: $error');
        });
  }

  Future<void> deletePerbaikan({String? id}) async {
    try {
      await db.collection("fasilitas_umum").doc(id).delete();
    } catch (e) {
      debugPrint("Gagal menghapus data: $e");
      throw Exception('Gagal menghapus data: $e');
    }
  }

  Future<void> addKriteria({String? nama, String? jenis, double? bobot}) async {
    try {
      final snapshot = await db.collection("kriteria").get();
      final currentCount = snapshot.docs.length;

      await db.collection("kriteria").add({
        "kode": currentCount + 1,
        "nama": nama,
        "jenis": jenis,
        "bobot": bobot,
        "created_at": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("ERROR ADD KRITERIA $e");
      throw Exception('Gagal menyimpan data: $e');
    }
  }

  Future<void> addKecamatan({
    String? nama,
    int? jumlahPenduduk,
    int? kepadatanPenduduk,
  }) async {
    try {
      await db.collection("kecamatan").add({
        "nama": nama,
        "kepadatan_penduduk": jumlahPenduduk,
        "jumlah_warga_terdampak": kepadatanPenduduk,
        "jumlah_fasilitas_rusak": 0, // Default value
        "created_at": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("ERROR ADD KRITERIA $e");
      throw Exception('Gagal menyimpan data: $e');
    }
  }

  Future<List<KecamatanModel>> getKecamatan() async {
    try {
      final snapshot = await db.collection("kecamatan").get();
      List<KecamatanModel> kecamatanList = [];
      for (var doc in snapshot.docs) {
        debugPrint("Kecamatan: ${doc.data()}");
        kecamatanList.add(
          KecamatanModel.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>,
          ),
        );
      }
      debugPrint("Jumlah kecamatan: ${kecamatanList.length}");
      return kecamatanList;
    } catch (e) {
      debugPrint("ERROR GET KECAMATAN $e");
      throw Exception('Gagal mengambil data kecamatan: $e');
    }
  }
}
