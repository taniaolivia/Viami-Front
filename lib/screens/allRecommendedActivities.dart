import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/generalTemplate.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/activity/activities.dart';
import 'package:viami/screens/activityDetails.dart';
import 'package:viami/screens/drawer.dart';
import 'package:viami/services/activity/recommendedActivities.service.dart';

class AllRecommendedActivitiesPage extends StatefulWidget {
  const AllRecommendedActivitiesPage({Key? key}) : super(key: key);

  @override
  State<AllRecommendedActivitiesPage> createState() =>
      _AllRecommendedActivitiesPageState();
}

class _AllRecommendedActivitiesPageState
    extends State<AllRecommendedActivitiesPage> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  List likedList = [];

  Future<Activities> getListRecommendedActivities() {
    Future<Activities> getAllRActivities() async {
      token = await storage.read(key: "token");

      return RecommendedActivitiesService()
          .getAllRecommendedActivities(token.toString());
    }

    return getAllRActivities();
  }

  @override
  void initState() {
    getListRecommendedActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: const DrawerPage(),
        body: GeneralTemplate(
            image: "${dotenv.env['CDN_URL']}/assets/travels.jpg",
            imageHeight: MediaQuery.of(context).size.width <= 320 ? 2.5 : 3.5,
            contentHeight: 5,
            containerHeight: 1.25,
            height: 1,
            title: "Nos recommendations",
            content: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 50, 20, MediaQuery.of(context).size.height / 3.5),
              child: FutureBuilder<Activities>(
                  future: getListRecommendedActivities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("");
                    }

                    if (snapshot.hasError) {
                      return Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                      );
                    }

                    if (!snapshot.hasData) {
                      return Text("");
                    }

                    var activity = snapshot.data!;

                    return Column(
                        children:
                            List.generate(activity.activities.length, (index) {
                      return Column(children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadePageRoute(
                                  page: ActivityDetailsPage(
                                      activityId:
                                          activity.activities[index].id),
                                ),
                              );
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    border: Border.all(
                                      width: 2,
                                      color: const Color(0xFFDADADA),
                                    ),
                                    color: const Color(0xFFEDEEEF),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 10.0,
                                        spreadRadius: 3.0,
                                        offset: Offset(
                                          5.0,
                                          5.0,
                                        ),
                                      )
                                    ]),
                                child: Column(children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width <=
                                            320
                                        ? MediaQuery.of(context).size.height / 4
                                        : MediaQuery.of(context).size.height /
                                            6,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 10.0,
                                            spreadRadius: 0.0,
                                            offset: Offset(
                                              5.0,
                                              5.0,
                                            ),
                                          )
                                        ],
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              activity
                                                  .activities[index].imageName,
                                            ))),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: AutoSizeText(
                                                toBeginningOfSentenceCase(
                                                    activity.activities[index]
                                                        .name)!,
                                                maxLines: 2,
                                                minFontSize: 16,
                                                maxFontSize: 20,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Color(0xFF0A2753)))),
                                        /*Row(children: [
                                          const Icon(
                                            Icons.people_alt,
                                            size: 20,
                                            color: Color(0xFF0081CF),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          AutoSizeText(
                                              activity.activities[index]
                                                          .nbParticipant ==
                                                      null
                                                  ? 0.toString()
                                                  : activity.activities[index]
                                                      .nbParticipant
                                                      .toString(),
                                              minFontSize: 12,
                                              maxFontSize: 18,
                                              style: const TextStyle(
                                                  color: Color(0xFF0A2753))),
                                        ])*/
                                      ]),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 20,
                                          color: Color(0xFF0081CF),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        AutoSizeText(
                                            toBeginningOfSentenceCase(activity
                                                .activities[index].location)!,
                                            minFontSize: 12,
                                            maxFontSize: 18,
                                            style: const TextStyle(
                                                color: Color(0xFF0A2753))),
                                      ])
                                ]))),
                        const SizedBox(
                          height: 40,
                        )
                      ]);
                    }).toList());
                  }),
            ))));
  }
}
