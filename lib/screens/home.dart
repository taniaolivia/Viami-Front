import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viami/components/locationPermission.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/screens/activityDetails.dart';
import 'package:viami/screens/faq.dart';
import 'package:viami/screens/popularTheme.dart';
import 'package:viami/screens/recommendationActivity.dart';
import 'package:viami/services/travelActivity/travelsActivities.service.dart';
import 'package:viami/services/user/user.service.dart';

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
  String? currentLocation;
  bool? tokenExpired;

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

    return UserService().getUserById(userId.toString(), token.toString());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<String?> getCurrentPosition(BuildContext context) async {
      var location = await getMyCurrentPositionLatLon(context);

      setState(() {
        currentLocation = location;
      });

      return location;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: FutureBuilder<User>(
              future: getUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.2,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF0081CF)),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Text(
                    '',
                    textAlign: TextAlign.center,
                  );
                }

                if (!snapshot.hasData) {
                  return const Text('');
                }

                var user = snapshot.data!;

                return Column(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 0, 5),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            "Salut ${toBeginningOfSentenceCase(user.firstName)},",
                            minFontSize: 15,
                            maxFontSize: 18,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Color(0xFF39414B),
                                fontWeight: FontWeight.w300),
                          ))),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                      child: AutoSizeText(
                        "Trouvez votre partenaire pour voyager",
                        minFontSize: 22,
                        maxFontSize: 25,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(0xFF0A2753),
                            fontWeight: FontWeight.bold),
                      )),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                        child: AutoSizeText(
                          "Activités",
                          minFontSize: 18,
                          maxFontSize: 20,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A2753)),
                        ),
                      )),
                  const PopularThemePage(),
                  const RecommendationActivityPage(),
                  const FaqPage(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 50),
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
                        FutureBuilder(
                            future: TravelsActivitiesService()
                                .getAllTravelActivitiesTest(token.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (snapshot.hasError || !snapshot.hasData) {
                                return Text('${snapshot.error}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black));
                              }

                              var activities = snapshot.data!["data"];

                              return FutureBuilder<String?>(
                                future: getMyCurrentPositionLatLon(context),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (snapshot.hasError || !snapshot.hasData) {
                                    return Text('${snapshot.error}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.black));
                                  }

                                  var currentLocation = snapshot.data!;

                                  return GestureDetector(
                                      onTapDown: (details) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                  surfaceTintColor:
                                                      Colors.transparent,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Column(children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              1.3,
                                                      child: FlutterMap(
                                                        options: MapOptions(
                                                          center: LatLng(
                                                            double.parse(
                                                                currentLocation
                                                                    .split(
                                                                        ", ")[0]),
                                                            double.parse(
                                                                currentLocation
                                                                    .split(
                                                                        ", ")[1]),
                                                          ),
                                                          zoom: 11.6,
                                                        ),
                                                        children: [
                                                          TileLayer(
                                                            urlTemplate:
                                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                            userAgentPackageName:
                                                                'com.example.app',
                                                          ),
                                                          MarkerLayer(markers: [
                                                            Marker(
                                                              width: 40.0,
                                                              height: 40.0,
                                                              point: LatLng(
                                                                double.parse(
                                                                    currentLocation
                                                                        .split(
                                                                            ", ")[0]),
                                                                double.parse(
                                                                    currentLocation
                                                                        .split(
                                                                            ", ")[1]),
                                                              ),
                                                              builder: (BuildContext
                                                                      ctx) =>
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return Dialog(
                                                                                  child: GestureDetector(
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: UnconstrainedBox(
                                                                                          child: Container(
                                                                                              width: MediaQuery.of(context).size.width / 2,
                                                                                              child: const Column(
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                    height: 20,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "Votre position",
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(fontWeight: FontWeight.w600, color: Color.fromARGB(255, 10, 48, 79)),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 20,
                                                                                                  ),
                                                                                                ],
                                                                                              )))));
                                                                            });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .location_on,
                                                                          color:
                                                                              Colors.red,
                                                                          size:
                                                                              40.0,
                                                                        ),
                                                                      )),
                                                            )
                                                          ]),
                                                          MarkerLayer(
                                                              markers:
                                                                  List.generate(
                                                                      activities
                                                                          .length,
                                                                      (index) {
                                                            return Marker(
                                                              width: 40.0,
                                                              height: 40.0,
                                                              point: LatLng(
                                                                double.parse(
                                                                    activities[
                                                                            index]
                                                                        [
                                                                        "activityLatitude"]),
                                                                double.parse(
                                                                    activities[
                                                                            index]
                                                                        [
                                                                        "activityLongitude"]),
                                                              ),
                                                              builder: (BuildContext
                                                                      ctx) =>
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return Dialog(
                                                                                  child: GestureDetector(
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: UnconstrainedBox(
                                                                                          child: Container(
                                                                                              width: MediaQuery.of(context).size.width / 2,
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  const SizedBox(
                                                                                                    height: 20,
                                                                                                  ),
                                                                                                  const Text(
                                                                                                    "Activité",
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color.fromARGB(255, 10, 48, 79)),
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    height: 10,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    activities[index]["activityName"],
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    height: 20,
                                                                                                  ),
                                                                                                  ElevatedButton(
                                                                                                      onPressed: () {
                                                                                                        Navigator.push(context, FadePageRoute(page: ActivityDetailsPage(activityId: activities[index]["idActivity"])));
                                                                                                      },
                                                                                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xFF0081CF))),
                                                                                                      child: const Text("Découvrir", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white))),
                                                                                                  const SizedBox(
                                                                                                    height: 20,
                                                                                                  ),
                                                                                                ],
                                                                                              )))));
                                                                            });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .location_on,
                                                                          color:
                                                                              Colors.blue,
                                                                          size:
                                                                              40.0,
                                                                        ),
                                                                      )),
                                                            );
                                                          }))
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    const Color(
                                                                        0xFF0081CF))),
                                                        child: const Text(
                                                            "Fermer",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white))),
                                                  ]));
                                            });
                                      },
                                      child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3.5,
                                              child: FlutterMap(
                                                options: MapOptions(
                                                  center: LatLng(
                                                    double.parse(currentLocation
                                                        .split(", ")[0]),
                                                    double.parse(currentLocation
                                                        .split(", ")[1]),
                                                  ),
                                                  zoom: 11.6,
                                                ),
                                                children: [
                                                  TileLayer(
                                                    urlTemplate:
                                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                    userAgentPackageName:
                                                        'com.example.app',
                                                  ),
                                                  MarkerLayer(markers: [
                                                    Marker(
                                                      width: 40.0,
                                                      height: 40.0,
                                                      point: LatLng(
                                                        double.parse(
                                                            currentLocation
                                                                .split(
                                                                    ", ")[0]),
                                                        double.parse(
                                                            currentLocation
                                                                .split(
                                                                    ", ")[1]),
                                                      ),
                                                      builder: ((context) =>
                                                          Container(
                                                            child: const Icon(
                                                              Icons.location_on,
                                                              color: Colors.red,
                                                              size: 40.0,
                                                            ),
                                                          )),
                                                    )
                                                  ]),
                                                  MarkerLayer(
                                                      markers: List.generate(
                                                          activities.length,
                                                          (index) {
                                                    return Marker(
                                                      width: 40.0,
                                                      height: 40.0,
                                                      point: LatLng(
                                                        double.parse(activities[
                                                                index][
                                                            "activityLatitude"]),
                                                        double.parse(activities[
                                                                index][
                                                            "activityLongitude"]),
                                                      ),
                                                      builder: ((context) =>
                                                          Container(
                                                            child: const Icon(
                                                              Icons.location_on,
                                                              color:
                                                                  Colors.blue,
                                                              size: 40.0,
                                                            ),
                                                          )),
                                                    );
                                                  }))
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  9,
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color.fromARGB(
                                                              108, 0, 0, 0)),
                                                  child: const Text(
                                                    'Appuyez et maintenez pour interagir',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  )),
                                            ),
                                          ]));
                                },
                              );
                            }),
                        const SizedBox(height: 70),
                      ],
                    ),
                  ),
                ]);
              }),
        ));
  }
}
