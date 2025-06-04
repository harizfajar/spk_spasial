import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spk/pages/fasilitasPerbaikan/notifier/perbaikan_notifier.dart';
import 'package:spk/pages/map/notifier/maps_notifier.dart';

class PilihLokasi extends ConsumerStatefulWidget {
  const PilihLokasi({Key? key}) : super(key: key);

  @override
  ConsumerState<PilihLokasi> createState() => _PilihLokasiState();
}

class _PilihLokasiState extends ConsumerState<PilihLokasi> {
  @override
  Widget build(BuildContext context) {
    final initialPosition = ref.watch(lokasiNotifierProvider);
    final fasilitas = ref.watch(perbaikanNotifierProvider);
    final fasilitasNotifier = ref.read(perbaikanNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text("Pilih Lokasi di Peta")),
      body:
          initialPosition == null
              ? Text("Tunggu...")
              : FlutterMap(
                options: MapOptions(
                  initialCenter: initialPosition,
                  initialZoom: 15,
                  onTap: (tapPosition, latlng) {
                    fasilitasNotifier.setLocation(latlng);
                  },
                ),

                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  CurrentLocationLayer(
                    style: LocationMarkerStyle(
                      marker: const DefaultLocationMarker(
                        child: Icon(Icons.location_on, color: Colors.white),
                      ),
                      markerSize: const Size(35, 35),
                      markerDirection: MarkerDirection.heading,
                    ),
                  ),
                  if (fasilitas.value!.lokasi != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: fasilitas.value!.lokasi!,
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
