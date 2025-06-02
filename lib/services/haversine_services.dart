import 'dart:math';

double hitungJarak(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371; // Radius Bumi dalam kilometer
  double dLat = _deg2rad(lat2 - lat1);
  double dLon = _deg2rad(lon2 - lon1);
  double a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = R * c; // Jarak dalam kilometer
  print("Jarak: $distance km");
  return distance;
}

double _deg2rad(double deg) {
  return deg * (pi / 180);
}
