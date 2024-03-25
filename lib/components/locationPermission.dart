import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

String? _currentLocation;
Position? _currentPosition;

Future<bool> _handleLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}

Future<String?> _getAddressFromLatLng(Position position) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    _currentLocation = '${place.locality}, ${place.country}';
    return _currentLocation;
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}

Future<String?> getMyCurrentPosition(BuildContext context) async {
  final hasPermission = await _handleLocationPermission(context);
  if (!hasPermission) {
    return null;
  } else {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return await _getAddressFromLatLng(_currentPosition!);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}

Future<String?> getMyCurrentPositionLatLon(BuildContext context) async {
  final hasPermission = await _handleLocationPermission(context);
  if (!hasPermission) {
    return null;
  } else {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return "${_currentPosition?.latitude}, ${_currentPosition?.longitude}";
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
