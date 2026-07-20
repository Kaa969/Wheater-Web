import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class LocationService {
  Future<String> getCurrentCity() async {

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    final LocationService locationService =
    LocationService();

    if (!serviceEnabled) {
      throw Exception("GPS belum aktif");
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {

      permission =
          await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception("Izin lokasi ditolak");
      }
    }

    if (permission ==
        LocationPermission.deniedForever) {

      throw Exception(
        "Permission ditolak permanen",
      );
    }

    Position position =
        await Geolocator.getCurrentPosition();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    return placemarks.first.locality ?? "Bandung";
  }
}