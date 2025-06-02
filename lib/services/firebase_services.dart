import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:spk/model/kecamatan_model.dart';

class FirebaseServices {
  final db = FirebaseFirestore.instance;

  Future<void> addPerbaikan({
    String? namaFasilitas,
    int? tingkatKerusakan,
    String? lokasiKecamatan,
    double? jarakKeKecamatan,
    LatLng? lokasi,
  }) async {
    try {
      await db.collection("fasilitas_umum").add({
        "nama_fasilitas": namaFasilitas,
        "tingkat_kerusakan": tingkatKerusakan,
        "lokasi_kecamatan": lokasiKecamatan,
        "prioritas": 0, // Default priority
        "jarak_ke_kecamatan": jarakKeKecamatan,
        "skor_saw": 0, // Default score
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

  Future<void> addKriteria({
    String? nama,
    String? jenis,
    double? bobot,
  }) async {
    try {
      final snapshot = await db.collection("kriteria").get();
      final currentCount = snapshot.docs.length;

      await db.collection("kriteria").add({
        "kode": "K${currentCount + 1}",
        "nama": nama,
        "jenis": jenis,
        "bobot": bobot,
        "created_at": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("ERROR ADD KRITERIA $e");
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
      print("ERROR ADD KRITERIA $e");
      throw Exception('Gagal menyimpan data: $e');
    }
  }

  Future<List<KecamatanModel>> getKecamatan() async {
    try {
      final snapshot = await db.collection("kecamatan").get();
      List<KecamatanModel> kecamatanList = [];
      for (var doc in snapshot.docs) {
        print("Kecamatan: ${doc.data()}");
        kecamatanList.add(
          KecamatanModel.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>,
          ),
        );
      }
      print("Jumlah kecamatan: ${kecamatanList.length}");
      return kecamatanList;
    } catch (e) {
      print("ERROR GET KECAMATAN $e");
      throw Exception('Gagal mengambil data kecamatan: $e');
    }
  }
}
