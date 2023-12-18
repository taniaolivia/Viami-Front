import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viami/components/dialogMessage.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/screens/faq.dart';
import 'package:viami/screens/popularTheme.dart';
import 'package:viami/screens/recommendationActivity.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  bool? tokenExpired;

  Future<void> checkAndRequestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status != PermissionStatus.granted) {
      status = await Permission.location.request();

      if (status != PermissionStatus.granted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Accès à la localisation refusé"),
              content: Text(
                "Pour utiliser cette fonctionnalité, veuillez autoriser l'accès à votre emplacement dans les paramètres de l'application.",
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<Position> _getCurrentLocation() async {
    var locationPermission = await Permission.location.status;

    if (locationPermission == PermissionStatus.granted) {
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } catch (e) {
        throw Exception("Erreur lors de la récupération de la position : $e");
      }
    } else {
      throw Exception("Permission d'emplacement refusée");
    }
  }

  Future<User> getUser() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    bool isTokenExpired = AuthService().isTokenExpired(token!);

    tokenExpired = isTokenExpired;

    return UserService().getUserById(userId.toString(), token.toString());
  }

  @override
  void initState() {
    super.initState();
    checkAndRequestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<User>(
              future: getUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(height: 28);
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return Text('');
                }

                var user = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      "Salut ${toBeginningOfSentenceCase(user.firstName)},",
                      minFontSize: 15,
                      maxFontSize: 18,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Color(0xFF39414B),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: AutoSizeText(
                "Trouve ton / ta partenaire pour voyager ?",
                minFontSize: 22,
                maxFontSize: 25,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xFF0A2753),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const PopularThemePage(),
            const RecommendationActivityPage(),
            const FaqPage(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      "La carte",
                      minFontSize: 18,
                      maxFontSize: 20,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2753),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<Position>(
                    future: _getCurrentLocation(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return Text(
                            'Erreur lors de la récupération de la position');
                      }

                      var currentLocation = snapshot.data!;
                      return Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: FlutterMap(
                          options: MapOptions(
                            center: LatLng(
                              currentLocation.latitude,
                              currentLocation.longitude,
                            ),
                            zoom: 9.2,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 40.0,
                                  height: 40.0,
                                  point: LatLng(
                                    currentLocation.latitude,
                                    currentLocation.longitude,
                                  ),
                                  builder: ((context) => Container(
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.blue,
                                          size: 40.0,
                                        ),
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
