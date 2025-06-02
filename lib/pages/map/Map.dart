import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:spk/pages/fasilitasPerbaikan/notifier/perbaikan_notifier.dart';
import 'package:spk/pages/map/notifier/maps_notifier.dart';
import 'package:spk/route/route_names.dart';
import 'package:spk/services/haversine_services.dart';
import 'package:spk/widgets/drawer.dart';

class Maps extends ConsumerStatefulWidget {
  const Maps({super.key});

  @override
  ConsumerState<Maps> createState() => _MapsState();
}

class _MapsState extends ConsumerState<Maps> {
  LatLng? currentPosition;
  final MapController mapController = MapController();
  LatLng? initialPosition;

  @override
  void initState() {
    super.initState();
    // determinePosition();
    ref.read(lokasiNotifierProvider.notifier).updateLocation();
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = ref.watch(lokasiNotifierProvider);
    final initialPosNotifier = ref.read(lokasiNotifierProvider.notifier);
    final fasilitasAsync = ref.watch(fasilitasRusakProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Peta Lokasi")),
      drawer: DrawerCust(),
      body: fasilitasAsync.when(
        data:
            (fasilitasList) =>
                initialPosition == null
                    ? const Center(child: Text("Tunggu sebentar..."))
                    : FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: initialPosition,
                        initialZoom: 18.0,
                        // minZoom: 0,
                        // maxZoom: 0,
                        onTap: (tapPosition, latLng) {
                          debugPrint(
                            "Koordinat dipilih ${latLng.latitude}, ${latLng.longitude}",
                          );
                          setState(() {
                            currentPosition = latLng;
                          });
                        },
                        onLongPress:
                            (tapPosition, point) => setState(() {
                              currentPosition = null;
                            }),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.uangq',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        CurrentLocationLayer(
                          style: LocationMarkerStyle(
                            marker: const DefaultLocationMarker(
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                            ),
                            markerSize: const Size(35, 35),
                            markerDirection: MarkerDirection.heading,
                          ),
                        ),
                        MarkerLayer(
                          markers: [
                            ...fasilitasList.map((f) {
                              return Marker(
                                width: 40,
                                height: 40,
                                point: LatLng(
                                  f.lokasi!.latitude,
                                  f.lokasi!.longitude,
                                ),
                                child: Icon(
                                  f.nama == "Jalan"
                                      ? Icons.remove_road
                                      : f.nama == "Saluran Air"
                                      ? Icons.water
                                      : Icons.light,
                                  color:
                                      f.nama == "Jalan"
                                          ? Colors.red
                                          : f.nama == "Saluran Air"
                                          ? Colors.blue
                                          : Colors.orange,
                                  size: 40,
                                ),
                              );
                            }),
                            // Marker lokasi yang dipilih user (tap)
                            if (currentPosition != null)
                              Marker(
                                width: 40,
                                height: 40,
                                point: currentPosition!,
                                child: Icon(
                                  Icons.add_location_alt,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) {
          // Handle error state
          print("Error: $e");
          return Center(
            child: Text(
              "Terjadi kesalahan saat memuat data: $e",
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'my_location',
            child: Icon(Icons.my_location),
            onPressed: () async {
              // setState(() {
              //   currentPosition = null;
              // });
              final newLocation =
                  await ref
                      .read(lokasiNotifierProvider.notifier)
                      .updateLocation();

              if (newLocation != null) {
                mapController.move(newLocation, 18.0); // atau animatedMove
              }
            },
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'navigasi',
            child: const Icon(Icons.add),
            onPressed: () {
              context.pushNamed(addPerbaikanFasilitas);
            },
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoom_in',
            child: const Icon(Icons.zoom_in),
            onPressed: () {
              final center = mapController.camera.center;
              final zoom = mapController.camera.zoom;
              mapController.move(center, zoom + 1);
            },
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoom_out',
            child: const Icon(Icons.zoom_out),
            onPressed: () {
              final center = mapController.camera.center;
              final zoom = mapController.camera.zoom;
              mapController.move(center, zoom - 1);
            },
          ),
        ],
      ),
    );
  }
}
