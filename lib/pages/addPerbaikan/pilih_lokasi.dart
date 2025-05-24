import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:spk/pages/addPerbaikan/notifier/add_perbaikan_notifier.dart';
import 'package:spk/pages/map/notifier/maps_notifier.dart';

class PilihLokasi extends ConsumerStatefulWidget {
  const PilihLokasi({Key? key}) : super(key: key);

  @override
  ConsumerState<PilihLokasi> createState() => _PilihLokasiState();
}

class _PilihLokasiState extends ConsumerState<PilihLokasi> {
  LatLng? _pickedLocation;
  LatLng? initialPosition;

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      _pickedLocation = latlng;
    });
  }

  void initState() {
    super.initState();
    ref.read(mapsNotifierProvider.notifier).updateLocation();
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = ref.watch(mapsNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Pilih Lokasi di Peta")),
      body:
          initialPosition != null
              ? FlutterMap(
                options: MapOptions(
                  initialCenter: initialPosition,
                  initialZoom: 15,
                  onTap: _handleTap,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  if (_pickedLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _pickedLocation!,
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
              )
              : Text("Tunggu..."),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_pickedLocation != null) {
            ref
                .read(pilihLokasiNotifierProvider.notifier)
                .setLocation(_pickedLocation!);
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
