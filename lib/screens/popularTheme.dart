import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/activity/activities.dart';
import 'package:viami/models-api/theme/themes.dart';
import 'package:viami/models-api/themeActivity/themeActivities.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/screens/activityDetails.dart';
import 'package:viami/screens/allThemeActivities.dart';
import 'package:viami/services/activity/activities.service.dart';
import 'package:viami/services/theme/themes.service.dart';
import 'package:viami/services/themeActivity/themesActivities.service.dart';
import 'package:viami/services/user/user.service.dart';

class PopularThemePage extends StatefulWidget {
  const PopularThemePage({super.key});

  @override
  _PopularThemePageState createState() => _PopularThemePageState();
}

class _PopularThemePageState extends State<PopularThemePage> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  bool? tokenExpired;
  String clicked = "popular";
  List themeActivityImage = [];
  List themeActivityName = [];
  List themeActivityLocation = [];
  List themeActivityId = [];
  int? currentIndex;
  int? clickedThemeId;
  String? clickedThemeName;

  List activities = [];

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  Future<Themes> getAllThemes() async {
    token = await storage.read(key: "token");

    return ThemesService().getAllThemes(token.toString());
  }

  Future<Activities> getTopFivePopularTravels() async {
    token = await storage.read(key: "token");

    return ActivitiesService().getFivePopularActivities(token.toString());
  }

  Future<ThemeActivities> getFirstFiveThemeActivities(int themeId) async {
    token = await storage.read(key: "token");

    return ThemesActivitiesService()
        .getFirstFiveActivitiesByTheme(token.toString(), themeId);
  }

  IconData getIconDataFromName(String iconName) {
    if (iconName == 'beach') {
      return Icons.beach_access;
    } else if (iconName == 'museum') {
      return Icons.museum;
    } else if (iconName == 'sport') {
      return Icons.sports_soccer;
    } else if (iconName == 'attraction') {
      return Icons.attractions;
    } else if (iconName == 'fastfood') {
      return Icons.fastfood;
    } else if (iconName == 'game') {
      return Icons.sports_esports;
    } else if (iconName == 'reduce_capacity') {
      return Icons.reduce_capacity;
    } else if (iconName == 'food_bank') {
      return Icons.food_bank;
    } else if (iconName == 'class_rounded') {
      return Icons.class_rounded;
    } else if (iconName == 'directions_boat') {
      return Icons.directions_boat;
    } else if (iconName == 'restaurant') {
      return Icons.restaurant;
    } else if (iconName == 'local_bar') {
      return Icons.local_bar;
    } else if (iconName == 'park') {
      return Icons.park;
    } else if (iconName == 'location_city') {
      return Icons.location_city;
    } else if (iconName == 'theater_comedy') {
      return Icons.theater_comedy;
    }

    return Icons.beach_access;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object>>(
        future: Future.wait([getTopFivePopularTravels(), getAllThemes()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height));
          }

          if (snapshot.hasError) {
            return const Text(
              '',
              textAlign: TextAlign.center,
            );
          }

          if (!snapshot.hasData) {
            return Text('');
          }

          var activity = snapshot.data![0] as Activities;
          var theme = snapshot.data![1] as Themes;

          return Column(children: [
            Swiper(
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        FadePageRoute(
                          page: clicked == "popular"
                              ? ActivityDetailsPage(
                                  activityId: activity.activities[index].id)
                              : ActivityDetailsPage(
                                  activityId: themeActivityId[index]),
                        ),
                      );
                    },
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: clicked == "popular"
                                    ? NetworkImage(
                                        activity.activities[index].imageName,
                                      )
                                    : NetworkImage(
                                        themeActivityImage[index],
                                      ))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: AutoSizeText(
                                    clicked == "popular"
                                        ? toBeginningOfSentenceCase(
                                            activity.activities[index].name)!
                                        : toBeginningOfSentenceCase(
                                            themeActivityName[index])!,
                                    minFontSize: 25,
                                    maxFontSize: 30,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 20.0,
                                            spreadRadius: 5.0,
                                            offset: Offset(
                                              0.0,
                                              0.0,
                                            ),
                                          )
                                        ],
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.blue),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    AutoSizeText(
                                      clicked == "popular"
                                          ? toBeginningOfSentenceCase(activity
                                              .activities[index].location)!
                                          : toBeginningOfSentenceCase(
                                              themeActivityLocation[index])!,
                                      minFontSize: 20,
                                      maxFontSize: 25,
                                      style: const TextStyle(
                                          shadows: [
                                            BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 20.0,
                                              spreadRadius: 5.0,
                                              offset: Offset(
                                                0.0,
                                                0.0,
                                              ),
                                            )
                                          ],
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ])
                            ])));
              },
              autoplay: true,
              itemCount: clicked == "popular"
                  ? activity.activities.length
                  : themeActivityImage.length,
              itemWidth: MediaQuery.of(context).size.width,
              itemHeight: MediaQuery.of(context).size.height / 2.9,
              layout: SwiperLayout.TINDER,
              pagination: SwiperPagination(
                  builder: const DotSwiperPaginationBuilder(
                      color: Color(0xFFDBE0E7),
                      activeColor: Color(0xFF0081CF),
                      activeSize: 15.0),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).size.height / 2.7, 0, 0)),
            ),
            TextButton(
                onPressed: () {
                  if (clicked == "popular") {
                    Navigator.pushNamed(context, "/activities/popular");
                  } else {
                    Navigator.push(
                      context,
                      FadePageRoute(
                          page: AllThemeActivitiesPage(
                              themeId: clickedThemeId!,
                              themeName: clickedThemeName!)),
                    );
                  }
                },
                child: const AutoSizeText(
                  "Voir tout",
                  maxLines: 1,
                  minFontSize: 11,
                  maxFontSize: 13,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: "Poppins",
                      color: Color(0xFF6A778B)),
                )),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                clicked = "popular";
                                activities = activity.activities;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 7,
                                shadowColor: clicked == "popular"
                                    ? const Color(0xFF0081CF)
                                    : Colors.transparent,
                                padding: const EdgeInsets.all(8),
                                backgroundColor: clicked == "popular"
                                    ? const Color(0xFF0081CF)
                                    : Colors.white,
                                surfaceTintColor: clicked == "popular"
                                    ? const Color(0xFF0081CF)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    side: BorderSide(
                                        color: clicked != "popular"
                                            ? const Color(0xFFD6D6D6)
                                            : const Color(0xFF0081CF),
                                        width: 2.0))),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_fire_department_outlined,
                                      color: clicked == "popular"
                                          ? Colors.white
                                          : const Color(0xFF6A778B)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  AutoSizeText(
                                    "Populaire",
                                    maxLines: 1,
                                    minFontSize: 11,
                                    maxFontSize: 13,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: clicked == "popular"
                                            ? Colors.white
                                            : const Color(0xFF6A778B)),
                                  )
                                ]),
                          )),
                      Row(
                          children:
                              List.generate(theme.themes.length, (indexTheme) {
                        return Container(
                            margin: const EdgeInsets.fromLTRB(6, 5, 0, 5),
                            child: ElevatedButton(
                              onPressed: () async {
                                themeActivityImage = [];
                                themeActivityName = [];
                                themeActivityLocation = [];
                                themeActivityId = [];

                                var themeTravel =
                                    await getFirstFiveThemeActivities(
                                        theme.themes[indexTheme].id);

                                List.generate(themeTravel.activities.length,
                                    (index) {
                                  themeActivityImage.add(
                                      themeTravel.activities[index].imageName);
                                  themeActivityName
                                      .add(themeTravel.activities[index].name);
                                  themeActivityLocation.add(
                                      themeTravel.activities[index].location);
                                  themeActivityId.add(
                                      themeTravel.activities[index].activityId);
                                }).toList();

                                setState(() {
                                  clicked = "theme";
                                  currentIndex = indexTheme;
                                  clickedThemeId = theme.themes[indexTheme].id;
                                  clickedThemeName =
                                      theme.themes[indexTheme].theme;

                                  activities = themeTravel.activities;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8),
                                  elevation: 7,
                                  shadowColor: clicked == "theme" &&
                                          currentIndex == indexTheme
                                      ? const Color(0xFF0081CF)
                                      : Colors.transparent,
                                  backgroundColor:
                                      clicked == "theme" && currentIndex == indexTheme
                                          ? const Color(0xFF0081CF)
                                          : Colors.white,
                                  surfaceTintColor:
                                      clicked == "theme" && currentIndex == indexTheme
                                          ? const Color(0xFF0081CF)
                                          : Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      side: BorderSide(
                                          color: clicked == "theme" &&
                                                  currentIndex == indexTheme
                                              ? const Color(0xFF0081CF)
                                              : const Color(0xFFD6D6D6),
                                          width: 2.0))),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        getIconDataFromName(
                                            theme.themes[indexTheme].icon),
                                        color: clicked == "theme" &&
                                                currentIndex == indexTheme
                                            ? Colors.white
                                            : const Color(0xFF6A778B)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    AutoSizeText(
                                      toBeginningOfSentenceCase(
                                          theme.themes[indexTheme].theme)!,
                                      maxLines: 1,
                                      minFontSize: 11,
                                      maxFontSize: 13,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: clicked == "theme" &&
                                                  currentIndex == indexTheme
                                              ? Colors.white
                                              : const Color(0xFF6A778B)),
                                    )
                                  ]),
                            ));
                      }))
                    ]))
          ]);
        });
  }
}
