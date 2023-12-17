import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/activity/activities.dart';
import 'package:viami/screens/activityDetails.dart';
import 'package:viami/services/activity/recommendedActivities.service.dart';

class RecommendationActivityPage extends StatefulWidget {
  const RecommendationActivityPage({Key? key}) : super(key: key);

  @override
  State<RecommendationActivityPage> createState() =>
      _RecommendationActivityPageState();
}

class _RecommendationActivityPageState
    extends State<RecommendationActivityPage> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  List likedList = [];

  Future<Activities> getListRecommendActivities() {
    Future<Activities> getAllRecommendActivities() async {
      token = await storage.read(key: "token");

      return RecommendedActivitiesService()
          .getFiveRecommendedActivities(token.toString());
    }

    return getAllRecommendActivities();
  }

  @override
  void initState() {
    getListRecommendActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 30,
      ),
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const AutoSizeText(
              "Recommandation",
              minFontSize: 18,
              maxFontSize: 20,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF0A2753)),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/activities/recommend');
                },
                child: const AutoSizeText(
                  "Voir tout",
                  minFontSize: 14,
                  maxFontSize: 16,
                  style: TextStyle(color: Color(0xFF0A2753)),
                ))
          ])),
      FutureBuilder<Activities>(
          future: getListRecommendActivities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(height: 320);
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return Text("");
            }

            var activity = snapshot.data!;

            return Container(
                constraints:
                    const BoxConstraints(minHeight: 280, maxHeight: 300),
                margin: const EdgeInsets.only(
                    left: 10, right: 0, top: 0, bottom: 30),
                child: ListView.builder(
                    itemCount: activity.activities.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 15, top: 20, bottom: 20),
                          child: Row(children: [
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
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width <=
                                                  320
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                                    "${dotenv.env['CDN_URL']}/assets/${activity.activities[index].imageName}",
                                                  ))),
                                          child: GestureDetector(onTap: () {
                                            setState(() {
                                              if (likedList.contains(index)) {
                                                likedList.removeWhere(
                                                    (element) =>
                                                        element == index);
                                              } else {
                                                likedList.add(index);
                                              }
                                            });
                                          })),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                                toBeginningOfSentenceCase(
                                                    activity.activities[index]
                                                        .name)!,
                                                minFontSize: 16,
                                                maxFontSize: 20,
                                                style: const TextStyle(
                                                    color: Color(0xFF0A2753))),
                                            Row(children: [
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
                                                      : activity
                                                          .activities[index]
                                                          .nbParticipant
                                                          .toString(),
                                                  minFontSize: 12,
                                                  maxFontSize: 16,
                                                  style: const TextStyle(
                                                      color:
                                                          Color(0xFF0A2753))),
                                            ])
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
                                                toBeginningOfSentenceCase(
                                                    activity.activities[index]
                                                        .location)!,
                                                minFontSize: 12,
                                                maxFontSize: 16,
                                                style: const TextStyle(
                                                    color: Color(0xFF6A778B))),
                                          ])
                                    ]))),
                            const SizedBox(
                              height: 40,
                            )
                          ]));
                    }));
          }),
    ]);
  }
}
