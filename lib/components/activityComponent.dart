import 'dart:ui';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viami/models-api/activity/activity.dart';
import 'package:viami/services/activity/activity.service.dart';
import 'package:viami/services/activityImage/activitiesImages.service.dart';
import 'package:viami/widgets/expandable_text_widget.dart';
import 'package:video_player/video_player.dart';
import '../widgets/icon_and_text_widget.dart';

class ActivityComponent extends StatefulWidget {
  final int activityId;
  const ActivityComponent({Key? key, required this.activityId})
      : super(key: key);

  @override
  State<ActivityComponent> createState() => _ActivityComponentState();
}

class _ActivityComponentState extends State<ActivityComponent> {
  int selectedImage = 0;
  final storage = const FlutterSecureStorage();
  List schedule = [];
  String? token = "";
  String? note;
  String? url = "";
  late CustomVideoPlayerController _customVideoPlayerController;
  late VideoPlayerController _videoPlayerController;

  List<String> activityImages = [];
  String? videoUrl = "";

  Future<void> getActivityImages() async {
    token = await storage.read(key: "token");

    final images = await ActivitiesImagesService()
        .getActivityImagesById(widget.activityId, token.toString());

    setState(() {
      activityImages = images.activityImages.map((image) {
        if (image.image.split(".")[3] == "mp4") {
          videoUrl = image.image;
          initializedVideoPlayer(videoUrl!);
        }

        return image.image;
      }).toList();
    });
  }

  Future<Activity> getActivityById() {
    Future<Activity> getActivity() async {
      token = await storage.read(key: "token");

      return ActivityService()
          .getActivityById(widget.activityId, token.toString());
    }

    return getActivity();
  }

  Future<void> fetchData() async {
    final activity = await getActivityById();

    setState(() {
      if (activity.note == null) {
        note = "0";
      } else {
        note = activity.note;
      }
    });

    await getActivityImages();

    //initializedVideoPlayer();
  }

  void initializedVideoPlayer(String url) {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((value) {
        setState(() {});
      });
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
    );
  }

  void _exitFullScreen() {
    // Set preferred orientations to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void initState() {
    fetchData();
    getActivityImages();
    super.initState();

    _exitFullScreen();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    _videoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: activityImages.isNotEmpty
                            ? CarouselSlider.builder(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 1,
                                  enlargeCenterPage: true,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.zoom,
                                ),
                                itemCount: activityImages.length,
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
                                                child: activityImages[index]
                                                            .split(".")[3] ==
                                                        "jpg"
                                                    ? Image.network(
                                                        activityImages[index])
                                                    : CustomVideoPlayer(
                                                        customVideoPlayerController:
                                                            _customVideoPlayerController,
                                                      ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Hero(
                                          tag: activityImages[index],
                                          child: activityImages[index]
                                                      .split(".")[3] ==
                                                  "jpg"
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          activityImages[
                                                              index]),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : CustomVideoPlayer(
                                                  customVideoPlayerController:
                                                      _customVideoPlayerController,
                                                )));
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
                                        Navigator.pop(context);
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
                    child: FutureBuilder<Object>(
                        future: getActivityById(),
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

                          var activity = snapshot.data! as Activity;

                          url = activity.url != null ? activity.url! : "";
                          schedule = activity.schedule != null
                              ? activity.schedule!.split(' | ')
                              : [];

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
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.15,
                                      child: AutoSizeText(
                                        activity.name,
                                        style: const TextStyle(
                                          color: Color(0xFF0A2753),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Poppins",
                                        ),
                                        minFontSize: 20,
                                        maxFontSize: 22,
                                        textAlign: TextAlign.left,
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Color(0xFF0081CF)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  AutoSizeText(
                                    activity.location,
                                    minFontSize: 11,
                                    maxFontSize: 13,
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconAndTextWidget(
                                    icon: Icons.star,
                                    text: "Note",
                                    subtext: note.toString(),
                                    color: Colors.black,
                                    iconColor: Colors.amber,
                                    /*onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                backgroundColor: Colors.white,
                                                surfaceTintColor: Colors.white,
                                                title: const Row(children: [
                                                  Text("Notez cette activité",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ]),
                                                alignment: Alignment.center,
                                                content: RatingBar.builder(
                                                  unratedColor:
                                                      const Color.fromARGB(
                                                          255, 218, 216, 216),
                                                  initialRating: note != null
                                                      ? note!.toDouble()
                                                      : 0.0,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: false,
                                                  itemCount: 5,
                                                  itemSize: 40,
                                                  itemBuilder: (context, _) =>
                                                      const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (value) {
                                                    setState(() {
                                                      note = value.toInt();
                                                    });
                                                  },
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Annuler',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await ActivityService()
                                                                .updateActivityNote(
                                                                    widget
                                                                        .activityId,
                                                                    note!
                                                                        .toDouble(),
                                                                    token
                                                                        .toString());

                                                            // Fermer la boîte de dialogue
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Enregistrer',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                        )
                                                      ]),
                                                ]);
                                          });
                                    },*/
                                  ),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (activity.address != null) {
                                        launchUrl(Uri.parse(
                                            "https://www.google.com/maps/search/?api=1&query=${activity.name},${activity.address}"));
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFFFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Icon(
                                              Icons.route,
                                              color: Color(0xFF0081CF),
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Align(
                                                alignment: Alignment.topLeft,
                                                child: AutoSizeText(
                                                  "Localisation",
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 171, 171, 172),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily: "Poppins",
                                                  ),
                                                  minFontSize: 10,
                                                  maxFontSize: 11,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  child: AutoSizeText(
                                                    activity.address != ""
                                                        ? activity.address!
                                                        : "-",
                                                    style: const TextStyle(
                                                      color: Color(0xFF0A2753),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily: "Poppins",
                                                    ),
                                                    minFontSize: 8,
                                                    maxFontSize: 10,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    textAlign: TextAlign.left,
                                                  ))
                                            ]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        if (activity.accessibility != "") {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                surfaceTintColor: Colors.white,
                                                backgroundColor: Colors.white,
                                                title: const Row(children: [
                                                  Icon(Icons.accessible),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Accessibilité",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ]),
                                                alignment: Alignment.center,
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(activity
                                                          .accessibility!)
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              "D'accord",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ))
                                                      ])
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFFFFFFFF),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child: Icon(
                                                Icons.accessible,
                                                color: Colors.black,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Align(
                                                  alignment: Alignment.topLeft,
                                                  child: AutoSizeText(
                                                    "Accessibilité",
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 171, 171, 172),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily: "Poppins",
                                                    ),
                                                    minFontSize: 10,
                                                    maxFontSize: 11,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    child: AutoSizeText(
                                                      activity.accessibility !=
                                                              ""
                                                          ? activity
                                                              .accessibility!
                                                          : "-",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF0A2753),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                      ),
                                                      minFontSize: 9,
                                                      maxFontSize: 10,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                    ))
                                              ]),
                                        ],
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        if (activity.language != null) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                surfaceTintColor: Colors.white,
                                                backgroundColor: Colors.white,
                                                title: const Row(children: [
                                                  Icon(Icons.language),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Langues",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ]),
                                                alignment: Alignment.center,
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(activity.language!)
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              "D'accord",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ))
                                                      ])
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFFFFFFFF),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child: Icon(
                                                Icons.language,
                                                color: Colors.black,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Align(
                                                  alignment: Alignment.topLeft,
                                                  child: AutoSizeText(
                                                    "Langues",
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 171, 171, 172),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily: "Poppins",
                                                    ),
                                                    minFontSize: 10,
                                                    maxFontSize: 11,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4,
                                                    child: AutoSizeText(
                                                      activity.language != ""
                                                          ? activity.language!
                                                          : "-",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF0A2753),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                      ),
                                                      minFontSize: 8,
                                                      maxFontSize: 10,
                                                      textAlign: TextAlign.left,
                                                    ))
                                              ]),
                                        ],
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(schedule.length,
                                      (indexDesc) {
                                    return Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          schedule[indexDesc],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: "Poppins",
                                          ),
                                          minFontSize: 12,
                                          maxFontSize: 14,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                        ));
                                  })),
                              const SizedBox(
                                height: 20,
                              ),
                              ExpandableTextWidget(
                                text: activity.description,
                              ),
                              const SizedBox(
                                height: 100,
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
                onPressed: () {
                  if (url != "") {
                    launchUrl(Uri.parse(url!));
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "Découvrir",
                      minFontSize: 11,
                      maxFontSize: 13,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
