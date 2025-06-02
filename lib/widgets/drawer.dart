import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spk/route/route_names.dart';

class DrawerCust extends StatelessWidget {
  const DrawerCust({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Beranda'),
            onTap: () {
              context.pushNamed(beranda);
            },
          ),
          ListTile(
            leading: Icon(Icons.add_location_alt),
            title: const Text('Tambah Perbaikan Fasilitas'),
            onTap: () {
              context.pushNamed(addPerbaikanFasilitas);
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: const Text('Maps'),
            onTap: () {
              context.pushNamed(maps);
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: const Text('Lihat Data Fasilitas'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.add_circle),
            title: const Text('Tambah Kriteria'),
            onTap: () {
              context.pushNamed(addKriteria);
            },
          ),
          ListTile(
            leading: Icon(Icons.add_circle),
            title: const Text('Tambah Kecamatan'),
            onTap: () {
              context.pushNamed(addKecamatan);
            },
          ),
          ListTile(
            leading: Icon(Icons.calculate),
            title: const Text('Perhitungan SAW'),
            onTap: () {
              context.pushNamed(perhitunganSAW);
            },
          ),
        ],
      ),
    );
  }
}
