import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class FirebaseServices {
  final db = FirebaseFirestore.instance;

  Future<void> addPerbaikan({
    String? namaFasilitas,
    String? tingkatKerusakan,
    String? wargaTerdampak,
    String? kepadatan,
    String? lokasiKecamatan,
    String? biaya,
    LatLng? lokasi,
  }) async {
    try {
      await db.collection("fasilitas_umum").add({
        "nama_fasilitas": namaFasilitas,
        "tingkat_kerusakan": tingkatKerusakan,
        "warga_terdampak": wargaTerdampak,
        "kepadatan": kepadatan,
        "lokasi_kecamatan": lokasiKecamatan,
        "prioritas": 0, // Default priority
        "jarak_ke_kecamatan": 0, // Default distance
        "skor_saw": 0, // Default score
        "biaya": biaya,
        "lokasi": {
          "latitude": lokasi?.latitude,
          "longitude": lokasi?.longitude,
        },
        "created_at": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("ERROR ADD FASILITAS $e");
      throw Exception('Gagal menyimpan data: $e');
    }
  }
}
