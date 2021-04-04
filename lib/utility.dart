import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng> acquireCurrentLocation() async {
  Location location = new Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }
  final locationData = await location.getLocation();
  return LatLng(locationData.latitude, locationData.longitude);
}