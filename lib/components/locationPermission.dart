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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Accès à la localisation refusé",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Text(
            "Pour utiliser cette fonctionnalité, veuillez autoriser l'accès à votre emplacement dans les paramètres de l'application.",
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "J'ai compris",
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Accès à la localisation refusé",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Text(
              "Pour utiliser cette fonctionnalité, veuillez autoriser l'accès à votre emplacement dans les paramètres de l'application.",
              textAlign: TextAlign.justify,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "J'ai compris",
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Accès à la localisation refusé",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Text(
            "Pour utiliser cette fonctionnalité, veuillez autoriser l'accès à votre emplacement dans les paramètres de l'application.",
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "J'ai compris",
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    //debugPrint(e.toString());
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
      //debugPrint(e.toString());
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
      //debugPrint(e.toString());
      return null;
    }
  }
}
