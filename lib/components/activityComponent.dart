import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/activity/activity.dart';
import 'package:viami/services/activity/activity.service.dart';
import 'package:viami/services/activityImage/activitiesImages.service.dart';
import 'package:viami/widgets/expandable_text_widget.dart';
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

  String? token = "";
  int? note;

  List<String> activityImages = [];

  Future<void> getActivityImages() async {
    token = await storage.read(key: "token");

    final images = await ActivitiesImagesService()
        .getActivityImagesById(widget.activityId, token.toString());

    setState(() {
      activityImages = images.activityImages.map((image) {
        return '${dotenv.env['CDN_URL']}/assets/${image.imageName}';
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
        note = 0;
      } else {
        note = activity.note;
      }
    });

    await getActivityImages();
  }

  @override
  void initState() {
    fetchData();
    super.initState();
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
                        child: PageView.builder(
                          itemCount: activityImages.length,
                          controller: PageController(viewportFraction: 1.0),
                          onPageChanged: (int index) {
                            setState(() {
                              selectedImage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      activityImages[selectedImage]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      activityImages.length,
                                      (index) => buildDot(index: index),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
                                height: MediaQuery.of(context).size.height ) 
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return const Text('');
                          }

                          var activity = snapshot.data! as Activity;

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
                                    activity.name,
                                    style: const TextStyle(
                                      color: Color(0xFF0A2753),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins",
                                    ),
                                    minFontSize: 25,
                                    maxFontSize: 28,
                                    textAlign: TextAlign.center,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Color.fromARGB(255, 228, 241, 247),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.favorite,
                                          color: Color(0xFF0081CF),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconAndTextWidget(
                                    icon: Icons.location_on,
                                    text: activity.location,
                                    color: Colors.black,
                                    iconColor: const Color(0xFF0081CF),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconAndTextWidget(
                                    icon: Icons.star,
                                    text: note.toString(),
                                    color: Colors.black,
                                    iconColor: Colors.yellow,
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text(
                                                    'Notez cette activité'),
                                                content: RatingBar.builder(
                                                  initialRating: note != null ? note!.toDouble() : 0.0,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: false,
                                                  itemCount: 5,
                                                  itemSize: 40,
                                                  itemBuilder: (context, _) =>
                                                      Icon(
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
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Annuler'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await ActivityService()
                                                          .updateActivityNote(
                                                              widget.activityId,
                                                              note!.toDouble(),
                                                              token.toString());

                                                      // Fermer la boîte de dialogue
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Enregistrer'),
                                                  ),
                                                ]);
                                          });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ExpandableTextWidget(
                                text: activity.description,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          );
                        })),
              ],
            ),
          ),
        ),
        floatingActionButton: Expanded(
            child: Container(
                height: 50.0,
                width: 250.00,
                child: FloatingActionButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    onPressed: () {
                      Navigator.pushNamed(context, "/profile");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        AutoSizeText(
                          "Réserver",
                          minFontSize: 11,
                          maxFontSize: 13,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Widget buildDot({required int index}) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: selectedImage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
