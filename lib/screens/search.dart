import 'dart:async';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/generalTemplate.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/forum/forum.dart';
import 'package:viami/models-api/forum/forumCities.dart';
import 'package:viami/models-api/forum/forumComments.dart';
import 'package:viami/models-api/forum/forumPostsCity.dart';
import 'package:viami/models-api/travel/travels.dart';
import 'package:viami/screens/payment.dart';
import 'package:viami/screens/searchTravel.dart';
import 'package:viami/services/forum/forum.service.dart';
import 'package:viami/services/forum/forumCities.service.dart';
import 'package:viami/services/forum/forumComments.service.dart';
import 'package:viami/services/forum/forumPostsCities.service.dart';
import 'package:viami/services/travel/travels.service.dart';
import 'package:viami/services/user-premium-plan/user_premium_plan_service.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String? token;
  String? selectedLocation;
  List locationList = [""];
  String fillDestination = "";
  String page = "rejoindre";
  TextEditingController messageController = TextEditingController();
  String? userId = "";
  String? userImage;
  String posted = "";
  Forum? posts;
  String switchTo = "newest";
  String reloadComments = "reload";
  ForumComments? postComments;
  ForumPostsCity? postsCity;
  TextEditingController commentController = TextEditingController();
  TextEditingController postCityController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool? showPremium;

  Future<ForumCities> getAllForumCities() {
    Future<ForumCities> getListForumCities() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return ForumCitiesService().getAllForumCities(token.toString());
    }

    return getListForumCities();
  }

  Future<ForumComments> getAllCommentsPost(int postId) async {
    token = await storage.read(key: "token");

    return ForumCommentsService()
        .getAllCommentsByPostId(token.toString(), postId);
  }

  Future<ForumPostsCity> getAllPostsCity(int cityId) async {
    token = await storage.read(key: "token");

    return ForumPostsCitiesService()
        .getAllPostsByCityId(token.toString(), cityId);
  }

  Future<Forum> getAllNewestForumPosts() {
    Future<Forum> getListNewestForumPosts() async {
      token = await storage.read(key: "token");

      return ForumService().getAllNewestPostsForum(token.toString());
    }

    return getListNewestForumPosts();
  }

  Future<Forum> getAllOldestForumPosts() {
    Future<Forum> getListOldestForumPosts() async {
      token = await storage.read(key: "token");

      return ForumService().getAllOldestPostsForum(token.toString());
    }

    return getListOldestForumPosts();
  }

  getDateTime(postedOn) {
    DateTime specificDateTime = DateTime.parse(postedOn);

    DateTime currentDateTime = DateTime.now();
    Duration difference = currentDateTime.difference(specificDateTime);

    if (difference.inMinutes < 60) {
      posted = "${difference.inMinutes}min";
    } else if (difference.inHours < 24) {
      posted = "${difference.inHours}h";
    } else {
      posted = "${difference.inDays}j";
    }
  }

  Future<Travels> getListTravels() {
    Future<Travels> getAllTravels() async {
      token = await storage.read(key: "token");

      return TravelsService().getAllTravels(token.toString());
    }

    return getAllTravels();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Accès à la localisation refusé",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Text(
              "Pour utiliser cette fonctionnalité, veuillez autoriser l'accès à votre emplacement dans les paramètres de l'application.",
              textAlign: TextAlign.justify,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "J'ai compris",
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Accès à la localisation refusé",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              content: Text(
                "Pour utiliser cette fonctionnalité, veuillez autoriser l'accès à votre emplacement dans les paramètres de l'application.",
                textAlign: TextAlign.justify,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "J'ai compris",
                    style: const TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Accès à la localisation refusé",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Text(
              "Pour utiliser cette fonctionnalité, veuillez autoriser l'accès à votre emplacement dans les paramètres de l'application.",
              textAlign: TextAlign.justify,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "J'ai compris",
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  @override
  void initState() {
    fillDestination = "";
    getListTravels();
    _handleLocationPermission();
    getAllForumCities();
    getAllNewestForumPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GeneralTemplate(
          image: page == "rejoindre"
              ? "${dotenv.env['CDN_URL']}/assets/rejoindre.jpg"
              : "${dotenv.env['CDN_URL']}/assets/forum.jpg",
          imageHeight: 3,
          content: showPremium != null && showPremium!
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 130, 20, 160),
                      color: Colors.transparent,
                      child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(155, 0, 128, 207),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const AutoSizeText(
                                    "Voir qui est déjà intéressé par ce voyage",
                                    minFontSize: 16,
                                    maxFontSize: 17,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
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
                                        ]),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const AutoSizeText(
                                    "Passez à Viami Premium pour profiter les fonctionnalités dans le forum !",
                                    minFontSize: 11,
                                    maxFontSize: 13,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
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
                                        ]),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            FadePageRoute(
                                                page: const PaymentPage()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.fromLTRB(
                                              40, 15, 40, 15),
                                          backgroundColor: Colors.white,
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)))),
                                      child: const AutoSizeText(
                                        "Passer au premium",
                                        maxLines: 1,
                                        minFontSize: 11,
                                        maxFontSize: 13,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: Color(0xFF0081CF)),
                                      ))
                                ],
                              )))))
              : SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      UnconstrainedBox(
                          child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 15, 40, 15),
                                        backgroundColor: page == "rejoindre"
                                            ? const Color(0xFF0081CF)
                                            : Colors.white,
                                        shadowColor: Colors.white,
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    child: AutoSizeText(
                                      "Rejoindre",
                                      maxLines: 1,
                                      minFontSize: 11,
                                      maxFontSize: 13,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: page == "rejoindre"
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        page = "rejoindre";
                                      });
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 15, 40, 15),
                                        backgroundColor: page != "rejoindre"
                                            ? const Color(0xFF0081CF)
                                            : Colors.white,
                                        shadowColor: Colors.white,
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    child: AutoSizeText(
                                      "Forum",
                                      maxLines: 1,
                                      minFontSize: 11,
                                      maxFontSize: 13,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: page != "rejoindre"
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        page = "forum";
                                      });
                                    },
                                  ),
                                ],
                              ))),
                      const SizedBox(height: 30.0),
                      page == "rejoindre"
                          ? const SearchTravelPage()
                          : FutureBuilder<List<Object>>(
                              future: Future.wait([
                                getAllForumCities(),
                                getAllNewestForumPosts(),
                                getAllOldestForumPosts()
                              ]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height));
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

                                var cities = snapshot.data![0] as ForumCities;

                                if (switchTo == "newest") {
                                  posts = snapshot.data![1] as Forum;
                                } else {
                                  posts = snapshot.data![2] as Forum;
                                }

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: List.generate(
                                            cities.forumCities.length,
                                            (index) {
                                              return GestureDetector(
                                                  onTap: () async {
                                                    var image =
                                                        await UsersImagesService()
                                                            .getUserImagesById(
                                                                userId
                                                                    .toString(),
                                                                token
                                                                    .toString());

                                                    var plan =
                                                        await UserPremiumPlansService()
                                                            .getUserPremiumPlan(
                                                                token
                                                                    .toString(),
                                                                userId
                                                                    .toString());

                                                    if (plan != null) {
                                                      var tokenExpired =
                                                          AuthService()
                                                              .isTokenExpired(
                                                                  plan.token);

                                                      if (tokenExpired) {
                                                        await UserService()
                                                            .updateUserPlanById(
                                                                userId
                                                                    .toString(),
                                                                "free",
                                                                token
                                                                    .toString());
                                                        setState(() {
                                                          showPremium = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          showPremium = false;
                                                        });
                                                      }
                                                    } else {
                                                      setState(() {
                                                        showPremium = true;
                                                      });
                                                    }
                                                    if (showPremium != null &&
                                                        showPremium! == false) {
                                                      postsCity =
                                                          await getAllPostsCity(
                                                              cities
                                                                  .forumCities[
                                                                      index]
                                                                  .id);

                                                      if (image.userImages
                                                              .length !=
                                                          0) {
                                                        showModalBottomSheet<
                                                            void>(
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  255),
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                                decoration: const BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                30.0),
                                                                        topRight:
                                                                            Radius.circular(
                                                                                30.0)),
                                                                    color: Colors
                                                                        .white),
                                                                height: MediaQuery.of(context)
                                                                        .size
                                                                        .height /
                                                                    1.3,
                                                                padding: postsCity!
                                                                        .forumPostsCities
                                                                        .isNotEmpty
                                                                    ? const EdgeInsets.fromLTRB(
                                                                        20,
                                                                        20,
                                                                        20,
                                                                        20)
                                                                    : const EdgeInsets.fromLTRB(
                                                                        0,
                                                                        20,
                                                                        0,
                                                                        20),
                                                                child: Column(
                                                                    children: [
                                                                      Container(
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              15),
                                                                          decoration:
                                                                              BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey.shade400))),
                                                                          child: Row(
                                                                            children: [
                                                                              const SizedBox(width: 20),
                                                                              CircleAvatar(
                                                                                backgroundImage: NetworkImage('${cities.forumCities[index].image['image']}'),
                                                                                minRadius: 15,
                                                                                maxRadius: 20,
                                                                              ),
                                                                              const SizedBox(width: 20),
                                                                              AutoSizeText("${toBeginningOfSentenceCase(cities.forumCities[index].city)!}", minFontSize: 11, maxFontSize: 13, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                                                                            ],
                                                                          )),
                                                                      Container(
                                                                          height:
                                                                              MediaQuery.of(context).size.height / 2.7,
                                                                          child: postsCity!.forumPostsCities.isNotEmpty
                                                                              ? ListView.builder(
                                                                                  controller: _scrollController,
                                                                                  itemCount: postsCity!.forumPostsCities.length,
                                                                                  scrollDirection: Axis.vertical,
                                                                                  itemBuilder: (context, postIndex) {
                                                                                    getDateTime(postsCity!.forumPostsCities[postIndex].postedOn);

                                                                                    return Align(
                                                                                        alignment: userId == postsCity!.forumPostsCities[postIndex].user['id'] ? Alignment.topRight : Alignment.topLeft,
                                                                                        child: UnconstrainedBox(
                                                                                            child: Container(
                                                                                                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                                                decoration: BoxDecoration(color: userId == postsCity!.forumPostsCities[postIndex].user["id"] ? const Color(0xFF0081CF) : const Color.fromARGB(255, 207, 207, 207), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                                                width: MediaQuery.of(context).size.width / 1.5,
                                                                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                                  const SizedBox(height: 20),
                                                                                                  Padding(
                                                                                                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                                          CircleAvatar(
                                                                                                            backgroundImage: NetworkImage('${postsCity!.forumPostsCities[postIndex].user['profileImage']}'),
                                                                                                            minRadius: 15,
                                                                                                            maxRadius: 20,
                                                                                                          ),
                                                                                                          const SizedBox(width: 10),
                                                                                                          AutoSizeText("${toBeginningOfSentenceCase(postsCity!.forumPostsCities[postIndex].user["firstName"])!} ${toBeginningOfSentenceCase(postsCity!.forumPostsCities[postIndex].user["lastName"])!}", minFontSize: 11, maxFontSize: 13, style: TextStyle(color: userId == postsCity!.forumPostsCities[postIndex].user["id"] ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
                                                                                                        ]),
                                                                                                        Padding(
                                                                                                            padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                                                                                            child: AutoSizeText(
                                                                                                              posted != "" ? posted : "",
                                                                                                              minFontSize: 11,
                                                                                                              maxFontSize: 13,
                                                                                                              style: TextStyle(color: userId == postsCity!.forumPostsCities[postIndex].user['id'] ? Colors.white : Colors.black, fontWeight: FontWeight.w500),
                                                                                                              textAlign: TextAlign.right,
                                                                                                            )),
                                                                                                      ])),
                                                                                                  const SizedBox(height: 20),
                                                                                                  UnconstrainedBox(child: Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), child: SizedBox(width: MediaQuery.of(context).size.width / 1.8, child: AutoSizeText(postsCity!.forumPostsCities[postIndex].post, minFontSize: 13, maxFontSize: 15, textAlign: TextAlign.justify, style: TextStyle(color: userId == postsCity!.forumPostsCities[postIndex].user["id"] ? Colors.white : Colors.black))))),
                                                                                                  const SizedBox(
                                                                                                    height: 20,
                                                                                                  ),
                                                                                                ]))));
                                                                                  })
                                                                              : Padding(padding: const EdgeInsets.fromLTRB(0, 40, 0, 0), child: const Text("Devenez le premier à postqer !"))),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                          children: [
                                                                            Form(
                                                                                key: _formKey,
                                                                                child: Expanded(
                                                                                    child: TextFormField(
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return 'Veuillez remplir un message';
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                  controller: postCityController,
                                                                                  decoration: const InputDecoration(
                                                                                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                                    labelText: 'Votre message',
                                                                                    labelStyle: TextStyle(fontSize: 12),
                                                                                    focusedBorder: OutlineInputBorder(),
                                                                                    floatingLabelStyle: TextStyle(color: Color.fromARGB(255, 81, 81, 81)),
                                                                                    counterText: "",
                                                                                  ),
                                                                                  maxLength: 200,
                                                                                ))),
                                                                            const SizedBox(
                                                                              width: 15,
                                                                            ),
                                                                            ElevatedButton(
                                                                                onPressed: () async {
                                                                                  if (_formKey.currentState!.validate()) {
                                                                                    await ForumPostsCitiesService().addPostToForumCity(token.toString(), postCityController.text, userId.toString(), cities.forumCities[index].id);

                                                                                    postCityController.clear();

                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                                                                  backgroundColor: const Color(0xFF0081CF),
                                                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                ),
                                                                                child: const Icon(Icons.send, color: Colors.white)),
                                                                          ])
                                                                    ]));
                                                          },
                                                        );

                                                        postsCity!
                                                                .forumPostsCities
                                                                .isNotEmpty
                                                            ? Timer(
                                                                const Duration(
                                                                    milliseconds:
                                                                        100),
                                                                () => _scrollController.jumpTo(
                                                                    _scrollController
                                                                        .position
                                                                        .maxScrollExtent))
                                                            : null;
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  "Information"),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              surfaceTintColor:
                                                                  Colors.white,
                                                              titleTextStyle: const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              titlePadding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 25,
                                                                      top: 30),
                                                              backgroundColor:
                                                                  Colors.white,
                                                              content: const Text(
                                                                  "Veuillez ajouter une photo dans votre profil pour pouvoir poster !"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    messageController
                                                                        .clear();

                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
                                                                      'Fermer',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black)),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Column(children: [
                                                    CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          '${cities.forumCities[index].image['image']}'),
                                                      minRadius: 25,
                                                      maxRadius: 30,
                                                    ),
                                                    const SizedBox(
                                                        height: 10, width: 80),
                                                    AutoSizeText(
                                                      cities.forumCities[index]
                                                          .city,
                                                      minFontSize: 11,
                                                      maxFontSize: 13,
                                                    )
                                                  ]));
                                            },
                                          ),
                                        )),
                                    const SizedBox(height: 10),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (switchTo == "newest") {
                                                  switchTo = "oldest";
                                                } else {
                                                  switchTo = "newest";
                                                }
                                              });

                                              if (switchTo == "newest") {
                                                posts = getAllOldestForumPosts()
                                                    as Forum;
                                              } else {
                                                posts = getAllNewestForumPosts()
                                                    as Forum;
                                              }
                                            },
                                            icon: Icon(Icons.swap_vert,
                                                color: switchTo == "newest"
                                                    ? Colors.black
                                                    : Colors.blue))),
                                    const SizedBox(height: 10),
                                    posts!.forum.isNotEmpty
                                        ? SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                                children: List.generate(
                                                    posts!.forum.length,
                                                    (index) {
                                              getDateTime(
                                                  posts!.forum[index].postedOn);
                                              return Align(
                                                  alignment: userId ==
                                                          posts!.forum[index]
                                                              .user['id']
                                                      ? Alignment.topRight
                                                      : Alignment.topLeft,
                                                  child: UnconstrainedBox(
                                                      child: Container(
                                                          margin: const EdgeInsets.fromLTRB(
                                                              0, 0, 0, 10),
                                                          padding: const EdgeInsets.fromLTRB(
                                                              0, 20, 0, 10),
                                                          decoration: BoxDecoration(
                                                              color: userId == posts!.forum[index].user['id']
                                                                  ? const Color(
                                                                      0xFF0081CF)
                                                                  : const Color.fromARGB(
                                                                      255,
                                                                      207,
                                                                      207,
                                                                      207),
                                                              borderRadius:
                                                                  const BorderRadius.all(Radius.circular(20))),
                                                          width: MediaQuery.of(context).size.width / 1.35,
                                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                            width:
                                                                                15),
                                                                        CircleAvatar(
                                                                          backgroundImage:
                                                                              NetworkImage('${posts!.forum[index].user['profileImage']}'),
                                                                          minRadius:
                                                                              15,
                                                                          maxRadius:
                                                                              20,
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        AutoSizeText(
                                                                            "${toBeginningOfSentenceCase(posts!.forum[index].user["firstName"])!} ${toBeginningOfSentenceCase(posts!.forum[index].user["lastName"])!}",
                                                                            minFontSize:
                                                                                11,
                                                                            maxFontSize:
                                                                                13,
                                                                            style:
                                                                                TextStyle(color: userId == posts!.forum[index].user['id'] ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
                                                                      ]),
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          15,
                                                                          0,
                                                                          25,
                                                                          0),
                                                                      child: AutoSizeText(
                                                                          posted != ""
                                                                              ? posted
                                                                              : "",
                                                                          minFontSize:
                                                                              11,
                                                                          maxFontSize:
                                                                              13,
                                                                          style: TextStyle(
                                                                              color: userId == posts!.forum[index].user['id'] ? Colors.white : Colors.black,
                                                                              fontWeight: FontWeight.w500))),
                                                                ]),
                                                            const SizedBox(
                                                                height: 15),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        20,
                                                                        0,
                                                                        20,
                                                                        0),
                                                                child: AutoSizeText(
                                                                    posts!
                                                                        .forum[
                                                                            index]
                                                                        .post,
                                                                    minFontSize:
                                                                        11,
                                                                    maxFontSize:
                                                                        13,
                                                                    style: TextStyle(
                                                                        color: userId == posts!.forum[index].user['id']
                                                                            ? Colors
                                                                                .white
                                                                            : Colors
                                                                                .black,
                                                                        fontWeight:
                                                                            FontWeight.w500))),
                                                            const SizedBox(
                                                                height: 10),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        5,
                                                                        0,
                                                                        5,
                                                                        0),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: IconButton(
                                                                        onPressed: () async {
                                                                          var image = await UsersImagesService().getUserImagesById(
                                                                              userId.toString(),
                                                                              token.toString());

                                                                          postComments = await getAllCommentsPost(posts!
                                                                              .forum[index]
                                                                              .id);

                                                                          var plan = await UserPremiumPlansService().getUserPremiumPlan(
                                                                              token.toString(),
                                                                              userId.toString());

                                                                          if (plan !=
                                                                              null) {
                                                                            var tokenExpired =
                                                                                AuthService().isTokenExpired(plan.token);

                                                                            if (tokenExpired) {
                                                                              await UserService().updateUserPlanById(userId.toString(), "free", token.toString());
                                                                              setState(() {
                                                                                showPremium = true;
                                                                              });
                                                                            } else {
                                                                              setState(() {
                                                                                showPremium = false;
                                                                              });
                                                                            }
                                                                          } else {
                                                                            setState(() {
                                                                              showPremium = true;
                                                                            });
                                                                          }

                                                                          if (showPremium != null &&
                                                                              showPremium! == false) {
                                                                            if (image.userImages.length !=
                                                                                0) {
                                                                              showModalBottomSheet<void>(
                                                                                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return Container(
                                                                                      decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)), color: Colors.white),
                                                                                      height: MediaQuery.of(context).size.height / 1.3,
                                                                                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                                                                      child: Column(children: [
                                                                                        Container(
                                                                                            height: MediaQuery.of(context).size.height / 2.4,
                                                                                            child: postComments!.forumComments.isNotEmpty
                                                                                                ? ListView.builder(
                                                                                                    controller: _scrollController,
                                                                                                    itemCount: postComments!.forumComments.length,
                                                                                                    scrollDirection: Axis.vertical,
                                                                                                    itemBuilder: (context, index) {
                                                                                                      return Container(
                                                                                                          decoration: BoxDecoration(border: index + 1 != postComments!.forumComments.length ? Border(bottom: BorderSide(width: 1.0, color: Colors.grey.shade400)) : null),
                                                                                                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                                            const SizedBox(width: 15, height: 60),
                                                                                                            Column(children: [
                                                                                                              const SizedBox(height: 20),
                                                                                                              CircleAvatar(
                                                                                                                backgroundImage: NetworkImage('${postComments!.forumComments[index].user['profileImage']}'),
                                                                                                                minRadius: 15,
                                                                                                                maxRadius: 20,
                                                                                                              )
                                                                                                            ]),
                                                                                                            const SizedBox(width: 10),
                                                                                                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                                              const SizedBox(height: 20),
                                                                                                              AutoSizeText("${toBeginningOfSentenceCase(postComments!.forumComments[index].user["firstName"])!} ${toBeginningOfSentenceCase(postComments!.forumComments[index].user["lastName"])!}", minFontSize: 11, maxFontSize: 13, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                                                                                                              const SizedBox(height: 5),
                                                                                                              UnconstrainedBox(
                                                                                                                  child: SizedBox(
                                                                                                                      width: MediaQuery.of(context).size.width / 1.3,
                                                                                                                      child: AutoSizeText(
                                                                                                                        postComments!.forumComments[index].comment,
                                                                                                                        minFontSize: 13,
                                                                                                                        maxFontSize: 15,
                                                                                                                        textAlign: TextAlign.justify,
                                                                                                                      ))),
                                                                                                              const SizedBox(
                                                                                                                height: 20,
                                                                                                                width: 15,
                                                                                                              ),
                                                                                                            ]),
                                                                                                          ]));
                                                                                                    })
                                                                                                : const Text("Aucun commentaire")),
                                                                                        const SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Row(children: [
                                                                                          const SizedBox(
                                                                                            width: 15,
                                                                                          ),
                                                                                          Form(
                                                                                              key: _formKey,
                                                                                              child: Expanded(
                                                                                                  child: TextFormField(
                                                                                                validator: (value) {
                                                                                                  if (value == null || value.isEmpty) {
                                                                                                    return 'Veuillez remplir un message';
                                                                                                  }
                                                                                                  return null;
                                                                                                },
                                                                                                controller: commentController,
                                                                                                decoration: const InputDecoration(
                                                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                                                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                                                  labelText: 'Votre message',
                                                                                                  labelStyle: TextStyle(fontSize: 12),
                                                                                                  focusedBorder: OutlineInputBorder(),
                                                                                                  floatingLabelStyle: TextStyle(color: Color.fromARGB(255, 81, 81, 81)),
                                                                                                  counterText: "",
                                                                                                ),
                                                                                                maxLength: 200,
                                                                                              ))),
                                                                                          const SizedBox(
                                                                                            width: 15,
                                                                                          ),
                                                                                          ElevatedButton(
                                                                                              onPressed: () async {
                                                                                                if (_formKey.currentState!.validate()) {
                                                                                                  await ForumCommentsService().addCommentToPost(token.toString(), commentController.text, userId.toString(), posts!.forum[index].id);
                                                                                                  commentController.clear();

                                                                                                  Navigator.pop(context);
                                                                                                }
                                                                                              },
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                                                                                backgroundColor: const Color(0xFF0081CF),
                                                                                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                              ),
                                                                                              child: const Icon(Icons.send, color: Colors.white)),
                                                                                          const SizedBox(
                                                                                            width: 15,
                                                                                          ),
                                                                                        ])
                                                                                      ]));
                                                                                },
                                                                              );
                                                                              postComments!.forumComments.isNotEmpty ? Timer(const Duration(milliseconds: 100), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent)) : null;
                                                                            } else {
                                                                              showDialog(
                                                                                context: context,
                                                                                barrierDismissible: true,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    title: const Text("Information"),
                                                                                    alignment: Alignment.center,
                                                                                    surfaceTintColor: Colors.white,
                                                                                    titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black, fontFamily: "Poppins", fontWeight: FontWeight.bold),
                                                                                    titlePadding: const EdgeInsets.only(left: 25, top: 30),
                                                                                    backgroundColor: Colors.white,
                                                                                    content: const Text("Veuillez ajouter une photo dans votre profil pour pouvoir poster !"),
                                                                                    actions: [
                                                                                      TextButton(
                                                                                        onPressed: () {
                                                                                          messageController.clear();

                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        child: const Text('Fermer', style: TextStyle(color: Colors.black)),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              );
                                                                            }
                                                                          }
                                                                        },
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .comment,
                                                                          size:
                                                                              20,
                                                                          color:
                                                                              Colors.white,
                                                                        ))))
                                                          ]))));
                                            })))
                                        : SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3.5,
                                            child: const AutoSizeText(
                                              "Devenez le premier à poster !",
                                              minFontSize: 11,
                                              maxFontSize: 13,
                                            )),
                                  ],
                                );
                              }),
                    ])),
          contentHeight: 4,
          containerHeight: 1.25,
          height: 1.5,
          title: page == "rejoindre" ? "Rejoindre" : "Forum",
          redirect: "/home",
        ),
        floatingActionButton: page != "rejoindre"
            ? Container(
                height: 50.0,
                width: 50.00,
                margin: const EdgeInsets.fromLTRB(0, 0, 20, 70),
                child: FloatingActionButton(
                    elevation: 5,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.add, color: Colors.blue),
                    onPressed: () async {
                      var image = await UsersImagesService().getUserImagesById(
                          userId.toString(), token.toString());

                      var plan = await UserPremiumPlansService()
                          .getUserPremiumPlan(
                              token.toString(), userId.toString());

                      if (plan != null) {
                        var tokenExpired =
                            AuthService().isTokenExpired(plan.token);

                        if (tokenExpired) {
                          await UserService().updateUserPlanById(
                              userId.toString(), "free", token.toString());
                          setState(() {
                            showPremium = true;
                          });
                        } else {
                          setState(() {
                            showPremium = false;
                          });
                        }
                      } else {
                        setState(() {
                          showPremium = true;
                        });
                      }
                      if (showPremium != null && showPremium! == false) {
                        if (image.userImages.length != 0) {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Ajouter un post"),
                                alignment: Alignment.center,
                                surfaceTintColor: Colors.white,
                                titleTextStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600),
                                titlePadding:
                                    const EdgeInsets.only(left: 25, top: 30),
                                backgroundColor: Colors.white,
                                content: Form(
                                    key: _formKey,
                                    child: Expanded(
                                        child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez remplir un commentaire';
                                        }
                                        return null;
                                      },
                                      controller: messageController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        labelText: 'Message',
                                        labelStyle: TextStyle(fontSize: 12),
                                        focusedBorder: OutlineInputBorder(),
                                        floatingLabelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 81, 81, 81)),
                                      ),
                                      maxLength: 200,
                                    ))),
                                actions: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            messageController.clear();

                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Annuler',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              await ForumService().addPostForum(
                                                  token.toString(),
                                                  messageController.text,
                                                  userId.toString());

                                              setState(() {
                                                switchTo = "newest";
                                              });

                                              posts =
                                                  await getAllNewestForumPosts()
                                                      as Forum;

                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: const Text('Envoyer',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                      ])
                                ],
                              );
                            },
                          ).then((e) {
                            messageController.clear();
                          });
                        } else {
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
                                      messageController.clear();

                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Fermer',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {}
                    }))
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}
