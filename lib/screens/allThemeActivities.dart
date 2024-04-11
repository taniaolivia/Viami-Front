import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/generalTemplate.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/themeActivity/themeActivities.dart';
import 'package:viami/screens/activityDetails.dart';
import 'package:viami/screens/drawer.dart';
import 'package:viami/screens/travelDetails.dart';
import 'package:viami/services/themeActivity/themesActivities.service.dart';

class AllThemeActivitiesPage extends StatefulWidget {
  final int themeId;
  final String themeName;
  const AllThemeActivitiesPage(
      {Key? key, required this.themeId, required this.themeName})
      : super(key: key);

  @override
  State<AllThemeActivitiesPage> createState() => _AllThemeActivitiesPageState();
}

class _AllThemeActivitiesPageState extends State<AllThemeActivitiesPage> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  List likedList = [];

  @override
  Widget build(BuildContext context) {
    Future<ThemeActivities> getListActivitiesByTheme() {
      Future<ThemeActivities> getAllActivitiesByTheme() async {
        token = await storage.read(key: "token");

        return ThemesActivitiesService()
            .getAllActivitiesByTheme(token.toString(), widget.themeId);
      }

      return getAllActivitiesByTheme();
    }

    return Scaffold(
        backgroundColor: Colors.white,
        drawer: const DrawerPage(),
        body: GeneralTemplate(
            image: "${dotenv.env['CDN_URL']}/assets/travels.jpg",
            height: 1.0,
            imageHeight: MediaQuery.of(context).size.width <= 320 ? 2.5 : 3.5,
            contentHeight: MediaQuery.of(context).size.width <= 320 ? 3.5 : 4.3,
            containerHeight:
                MediaQuery.of(context).size.width <= 320 ? 1.4 : 1.3,
            title: widget.themeName,
            content: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 50, 20, MediaQuery.of(context).size.height / 3.5),
              child: FutureBuilder<ThemeActivities>(
                  future: getListActivitiesByTheme(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
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
                                      activityId: activity
                                          .activities[index].activityId!),
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
                                                minFontSize: 16,
                                                maxFontSize: 20,
                                                maxLines: 2,
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
