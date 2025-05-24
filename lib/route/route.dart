import 'package:go_router/go_router.dart';
import 'package:spk/pages/addPerbaikan/add_perbaikan.dart';
import 'package:spk/pages/addPerbaikan/pilih_lokasi.dart';
import 'package:spk/route/route_names.dart';
import 'package:spk/pages/map/Map.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  routerNeglect: false,
  initialLocation: maps,
  routes: [
    GoRoute(path: maps, name: maps, builder: (context, state) => Maps()),
    GoRoute(
      path: addPerbaikanFasilitas,
      name: addPerbaikanFasilitas,
      builder: (context, state) => AddPerbaikan(),
    ),
    GoRoute(
      path: pilihLokasi,
      name: pilihLokasi,
      builder: (context, state) => PilihLokasi(),
    ),
  ],
);
