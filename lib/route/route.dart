import 'package:go_router/go_router.dart';
import 'package:spk/pages/Kecamatan/addKecamatan.dart';
import 'package:spk/pages/Kriteria/addKriteria.dart';
import 'package:spk/pages/fasilitasPerbaikan/add_perbaikan.dart';
import 'package:spk/pages/fasilitasPerbaikan/pilih_lokasi.dart';
import 'package:spk/pages/beranda/beranda.dart';
import 'package:spk/pages/perhitunganSAW/perhitunganSAW.dart';
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
    GoRoute(
      path: beranda,
      name: beranda,
      builder: (context, state) => Beranda(),
    ),
    GoRoute(
      path: addKriteria,
      name: addKriteria,
      builder: (context, state) => AddKriteria(),
    ),
    GoRoute(
      path: perhitunganSAW,
      name: perhitunganSAW,
      builder: (context, state) => PerhituganSAW(),
    ),
    GoRoute(
      path: addKecamatan,
      name: addKecamatan,
      builder: (context, state) => AddKecamatan(),
    ),
  ],
);
