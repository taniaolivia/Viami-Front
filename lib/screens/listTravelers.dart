import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/screens/showProfile.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';
import 'package:viami/widgets/menu_widget.dart';

import 'drawer.dart';

class ListTravelersPage extends StatefulWidget {
  final List? users;
  final String? connectedUserPlan;
  const ListTravelersPage({Key? key, this.users, this.connectedUserPlan})
      : super(key: key);

  @override
  State<ListTravelersPage> createState() => _ListTravelersPageState();
}

class _ListTravelersPageState extends State<ListTravelersPage> {
  final storage = const FlutterSecureStorage();
  String? token;
  String userImages = "";
  String? userId = "";
  bool? tokenExpired;
  String connectedUserPlan = '';

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

  Future<UsersImages> getUsersImages(int index) async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return await UsersImagesService()
        .getUserImagesById(widget.users![index].userId, token.toString());
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            )),
        backgroundColor: const Color(0xFF0081CF),
      ),
      backgroundColor: Colors.white,
      drawer: const DrawerPage(),
      body: Stack(fit: StackFit.expand, children: [
        SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(32, 20, 32, 50),
                child: Column(children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        'Voyageurs',
                        minFontSize: 23,
                        maxFontSize: 26,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        'Retrouvez les voyageurs cherchant un duo pour cette conversation',
                        minFontSize: 10,
                        maxFontSize: 12,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.7)),
                      )),
                  const SizedBox(height: 20),
                  Row(children: const [
                    Expanded(
                        child: Divider(
                      color: Color.fromARGB(255, 188, 186, 190),
                    )),
                    SizedBox(width: 10),
                    AutoSizeText(
                      "Aujourd'hui",
                      minFontSize: 10,
                      maxFontSize: 12,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.7)),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Divider(
                      color: Color.fromARGB(255, 188, 186, 190),
                    ))
                  ]),
                  const SizedBox(height: 20),
                  Wrap(
                      direction: Axis.horizontal,
                      spacing: 10.0,
                      runSpacing: 20.0,
                      children: List.generate(widget.users!.length, (index) {
                        return FutureBuilder(
                            future:
                                Future.wait([getUser(), getUsersImages(index)]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (!snapshot.hasData) {
                                return const Text('');
                              }

                              var image = snapshot.data![1] as UsersImages;
                              var user = snapshot.data![0] as User;

                              connectedUserPlan = user.plan;

                              return widget.users![index].userId != userId
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            FadePageRoute(
                                                page: ShowProfilePage(
                                                    showButton: false,
                                                    userId: widget.users![index]
                                                        .userId)));
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.6,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.1),
                                            image: image.userImages.length != 0
                                                ? DecorationImage(
                                                    image: NetworkImage(image
                                                        .userImages[0].image),
                                                    fit: BoxFit.cover)
                                                : DecorationImage(
                                                    colorFilter:
                                                        const ColorFilter
                                                            .linearToSrgbGamma(),
                                                    image: NetworkImage(
                                                        "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                                    fit: BoxFit.contain,
                                                    alignment:
                                                        Alignment.center),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, bottom: 10),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: AutoSizeText(
                                                        "${toBeginningOfSentenceCase(widget.users![index].firstName)!}, ${widget.users![index].age}",
                                                        minFontSize: 16,
                                                        maxFontSize: 17,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            shadows: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black,
                                                                blurRadius:
                                                                    10.0,
                                                                spreadRadius:
                                                                    5.0,
                                                                offset: Offset(
                                                                  0.0,
                                                                  0.0,
                                                                ),
                                                              )
                                                            ]),
                                                      ))),
                                              Container(
                                                  width: double.infinity,
                                                  height: 40,
                                                  child: ElevatedButton(
                                                      onPressed: () {},
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                      .fromRGBO(
                                                                  0, 0, 0, 0.5),
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          20)))),
                                                      child: const Icon(
                                                        Icons.message_rounded,
                                                        color:
                                                            Color(0xFF0081CF),
                                                      )))
                                            ],
                                          )))
                                  : const SizedBox.shrink();
                            });
                      }).toList())
                ]))),
        widget.connectedUserPlan == 'free'
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 160, 30, 160),
                    color: Colors.transparent,
                    child: Container(
                        height: 80,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(155, 0, 128, 207),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
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
                              "Passez à Viami Premium pour voir tous les voyageurs et commencer à leur parler",
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
                                onPressed: () {},
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
                                  "Passer au Premium",
                                  maxLines: 1,
                                  minFontSize: 11,
                                  maxFontSize: 13,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Color(0xFF0081CF)),
                                ))
                          ],
                        ))),
              )
            : Container(),
      ]),
    );
  }
}
