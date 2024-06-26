import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/screens/listTravelers.dart';
import 'package:viami/screens/menus.dart';
import 'package:viami/services/travel/travel.service.dart';
import 'package:viami/services/travelActivity/travelsActivities.service.dart';
import 'package:viami/services/userDateLocation/usersDateLocation.service.dart';
import '../components/activity_card.dart';
import '../models-api/travel/travel.dart';
import '../models-api/travelActivity/travelsActivities.dart';
import '../services/travelImage/travelsImages.service.dart';
import '../widgets/expandable_text_widget.dart';
import '../widgets/icon_and_text_widget.dart';

class TravelComponent extends StatefulWidget {
  final int travelId;
  final int? nbParticipant;
  final String? location;
  final String? date;
  final List? users;
  final String? connectedUserPlan;

  const TravelComponent(
      {Key? key,
      required this.travelId,
      this.users,
      this.nbParticipant,
      this.location,
      this.date,
      this.connectedUserPlan})
      : super(key: key);

  @override
  State<TravelComponent> createState() => _TravelComponentState();
}

class _TravelComponentState extends State<TravelComponent> {
  int selectedImage = 0;
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  String? nbParticipant = "0";

  List<String> travelImages = [];

  Future<Travel> getTravelById() {
    Future<Travel> getTravel() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return TravelService().getTravelById(widget.travelId, token.toString());
    }

    return getTravel();
  }

  Future<void> getTravelImages() async {
    token = await storage.read(key: "token");

    final images = await TravelsImagesService()
        .getTravelImagesById(widget.travelId, token.toString());

    setState(() {
      travelImages = images.travelImages.map((image) {
        return image.imageName;
      }).toList();
    });
  }

  Future<TravelsActivities> getTravelActivities() {
    Future<TravelsActivities> getTravelActivitiesList() async {
      token = await storage.read(key: "token");
      return TravelsActivitiesService()
          .getTravelActivitiesById(widget.travelId, token.toString());
    }

    return getTravelActivitiesList();
  }

  Future<void> fetchData() async {
    await getTravelById();
    await getTravelImages();
  }

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Travel travel;
    TravelsActivities travelsActivities;

    setState(() {
      if (widget.nbParticipant == null) {
        nbParticipant = "0";
      } else {
        nbParticipant = widget.nbParticipant.toString();
      }
    });

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: travelImages.length != 0
                            ? CarouselSlider.builder(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 1,
                                  enlargeCenterPage: true,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.zoom,
                                ),
                                itemCount: travelImages.length,
                                itemBuilder: (context, index, i) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Image.network(
                                                  travelImages[index]),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Hero(
                                        tag: travelImages[index],
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  travelImages[index]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )),
                                  );
                                },
                              )
                            : Container(),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                width: 50,
                                height: 50,
                                margin: MediaQuery.of(context).size.width <= 320
                                    ? const EdgeInsets.fromLTRB(20, 20, 0, 0)
                                    : const EdgeInsets.fromLTRB(20, 30, 0, 0),
                                padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            FadePageRoute(
                                                page: const MenusPage(
                                              currentIndex: 0,
                                            )));
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Color.fromRGBO(0, 0, 0, 0.4),
                                        size: 20,
                                      ))
                                ])))),
                  ],
                ),
                Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: FutureBuilder<Travel>(
                        future: getTravelById(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height));
                          } else if (snapshot.hasError) {
                            return const Text(
                              '',
                              textAlign: TextAlign.center,
                            );
                          } else if (!snapshot.hasData) {
                            return const Text('');
                          }

                          travel = snapshot.data!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    travel.name,
                                    style: const TextStyle(
                                      color: Color(0xFF0A2753),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins",
                                    ),
                                    minFontSize: 25,
                                    maxFontSize: 28,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    const Icon(Icons.location_on,
                                        color: Color(0xFF0081CF)),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(travel.location,
                                        style: const TextStyle(
                                            color: Colors.black))
                                  ])
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              IconAndTextWidget(
                                icon: Icons.person,
                                text: "Participants",
                                subtext: nbParticipant!,
                                color: Colors.black,
                                iconColor: Colors.blue,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ExpandableTextWidget(
                                text: travel.description,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Row(
                                children: [
                                  AutoSizeText(
                                    "Activités proposées",
                                    style: TextStyle(
                                      color: Color(0xFF0A2753),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    minFontSize: 25,
                                    maxFontSize: 28,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Container(
                                  height: 250,
                                  child: FutureBuilder<TravelsActivities>(
                                      future: getTravelActivities(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 5, sigmaY: 5),
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height));
                                        } else if (snapshot.hasError) {
                                          return const Text(
                                            '',
                                            textAlign: TextAlign.center,
                                          );
                                        } else if (!snapshot.hasData) {
                                          return const Text('');
                                        }

                                        travelsActivities = snapshot.data!;

                                        return ListView.builder(
                                            itemCount: travelsActivities
                                                .travelActivities.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final activity = travelsActivities
                                                  .travelActivities[index];

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 15),
                                                child: Row(
                                                  children: [
                                                    ActivityCard(
                                                        activity: activity),
                                                  ],
                                                ),
                                              );
                                            });
                                      })),
                              const SizedBox(
                                height: 120,
                              ),
                            ],
                          );
                        })),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
            height: 50.0,
            width: 250.00,
            child: FloatingActionButton(
                backgroundColor: const Color(0xFF0081CF),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                onPressed: () async {
                  var userImage = await storage.read(key: "userImage");

                  if (userImage == 0) {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Information"),
                          alignment: Alignment.center,
                          surfaceTintColor: Colors.white,
                          titleTextStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold),
                          titlePadding:
                              const EdgeInsets.only(left: 25, top: 30),
                          backgroundColor: Colors.white,
                          content: const Text(
                              "Veuillez ajouter une photo dans votre profil pour pouvoir poster !"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Fermer',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    await UsersDateLocationService().joinTravel(
                        token!, userId!, widget.location!, widget.date!);

                    Navigator.push(
                        context,
                        FadePageRoute(
                            page: ListTravelersPage(
                          travelId: widget.travelId,
                          location: widget.location,
                          date: widget.date,
                          users: widget.users!,
                          connectedUserPlan: widget.connectedUserPlan,
                        )));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      nbParticipant == "0"
                          ? "$nbParticipant personne intéressée"
                          : "$nbParticipant personnes intéressées",
                      minFontSize: 11,
                      maxFontSize: 13,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
