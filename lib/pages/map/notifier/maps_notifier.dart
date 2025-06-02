import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'maps_notifier.g.dart';

@riverpod
class LokasiNotifier extends _$LokasiNotifier {
  @override
  LatLng? build() {
    // Nilai awal state = null
    return null;
  }

  Future<LatLng?> updateLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("⚠️ Layanan lokasi tidak aktif.");
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          debugPrint("⚠️ Izin lokasi tidak diberikan.");
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      state = latLng;
      debugPrint(
        "📍 Lokasi berhasil diperoleh: ${position.latitude}, ${position.longitude}",
      );
      return latLng;
    } catch (e) {
      debugPrint("❌ Gagal mengambil lokasi: $e");
    }
  }
}
