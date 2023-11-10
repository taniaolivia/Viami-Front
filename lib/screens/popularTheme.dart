import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/theme/themes.dart';
import 'package:viami/models-api/themeTravel/themesTravels.dart';
import 'package:viami/models-api/travel/travels.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/screens/allThemeTravels.dart';
import 'package:viami/screens/travel_page_details.dart';
import 'package:viami/services/theme/themes.service.dart';
import 'package:viami/services/themeTravel/themesTravels.service.dart';
import 'package:viami/services/travel/travels.service.dart';
import 'package:viami/services/user/auth.service.dart';
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
  List themeTravelImage = [];
  List themeTravelName = [];
  List themeTravelLocation = [];
  int? currentIndex;
  int? clickedThemeId;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      bool isTokenExpired = AuthService().isTokenExpired(token!);

      tokenExpired = isTokenExpired;

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  Future<Themes> getAllThemes() async {
    token = await storage.read(key: "token");

    return ThemessService().getAllThemes(token.toString());
  }

  Future<Travels> getTopFivePopularTravels() async {
    token = await storage.read(key: "token");

    return TravelsService().getFivePopularTravels(token.toString());
  }

  Future<ThemesTravels> getFirstFiveThemeTravels(int themeId) async {
    token = await storage.read(key: "token");

    return ThemesTravelsService()
        .getFirstFiveTravelsByTheme(token.toString(), themeId);
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
            return Text("");
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return Text('');
          }

          var travel = snapshot.data![0] as Travels;
          var theme = snapshot.data![1] as Themes;

          return Column(children: [
            Swiper(
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        FadePageRoute(
                          page: TravelPageDetails(
                              travelId: travel.travels[index].id.toString()),
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
                                        "${dotenv.env['CDN_URL']}/assets/${travel.travels[index].image}",
                                      )
                                    : NetworkImage(
                                        "${dotenv.env['CDN_URL']}/assets/${themeTravelImage[index]}",
                                      ))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                clicked == "popular"
                                    ? toBeginningOfSentenceCase(
                                        travel.travels[index].name)!
                                    : toBeginningOfSentenceCase(
                                        themeTravelName[index])!,
                                minFontSize: 25,
                                maxFontSize: 30,
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
                              ),
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
                                          ? toBeginningOfSentenceCase(
                                              travel.travels[index].location)!
                                          : toBeginningOfSentenceCase(
                                              themeTravelLocation[index])!,
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
                  ? travel.travels.length
                  : themeTravelImage.length,
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
                    Navigator.pushNamed(context, "/travels/popular");
                  } else {
                    Navigator.push(
                      context,
                      FadePageRoute(
                          page: AllThemeTravelsPage(themeId: clickedThemeId!)),
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
                          children: List.generate(theme.themes.length, (index) {
                        return Container(
                            margin: const EdgeInsets.fromLTRB(6, 5, 0, 5),
                            child: ElevatedButton(
                              onPressed: () async {
                                themeTravelImage = [];
                                themeTravelName = [];
                                themeTravelLocation = [];

                                clickedThemeId = theme.themes[index].id;

                                var themeTravel =
                                    await getFirstFiveThemeTravels(
                                        theme.themes[index].id);

                                List.generate(themeTravel.travels.length,
                                    (index) {
                                  themeTravelImage
                                      .add(themeTravel.travels[index].image);
                                  themeTravelName
                                      .add(themeTravel.travels[index].name);
                                  themeTravelLocation
                                      .add(themeTravel.travels[index].location);
                                }).toList();

                                setState(() {
                                  clicked = "theme";
                                  currentIndex = index;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8),
                                  elevation: 7,
                                  shadowColor: clicked == "theme" &&
                                          currentIndex == index
                                      ? const Color(0xFF0081CF)
                                      : Colors.transparent,
                                  backgroundColor: clicked == "theme" &&
                                          currentIndex == index
                                      ? const Color(0xFF0081CF)
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      side: BorderSide(
                                          color: clicked == "theme" &&
                                                  currentIndex == index
                                              ? const Color(0xFF0081CF)
                                              : const Color(0xFFD6D6D6),
                                          width: 2.0))),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.water,
                                        color: clicked == "theme" &&
                                                currentIndex == index
                                            ? Colors.white
                                            : const Color(0xFF6A778B)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    AutoSizeText(
                                      toBeginningOfSentenceCase(
                                          theme.themes[index].theme)!,
                                      maxLines: 1,
                                      minFontSize: 11,
                                      maxFontSize: 13,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: clicked == "theme" &&
                                                  currentIndex == index
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
