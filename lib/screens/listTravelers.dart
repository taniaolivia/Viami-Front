import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/alertMessage.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/screens/menus.dart';
import 'package:viami/screens/showProfile.dart';
import 'package:viami/screens/travelDetails.dart';
import 'package:viami/services/requestMessage/request_message_service.dart';
import 'package:viami/services/requestMessage/requests_messages_service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';

class ListTravelersPage extends StatefulWidget {
  final int travelId;
  final String? location;
  final String? date;
  final List? users;
  final String? connectedUserPlan;
  const ListTravelersPage(
      {Key? key,
      required this.travelId,
      this.location,
      this.date,
      this.users,
      this.connectedUserPlan})
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
  String connectedUserPlan = 'free';
  List? users;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");
      //bool isTokenExpired = AuthService().isTokenExpired(token!);

      //tokenExpired = isTokenExpired;
      users = widget.users;

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
    users = widget.users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  FadePageRoute(
                      page: TravelDetailsPage(
                          travelId: widget.travelId,
                          date: widget.date,
                          location: widget.location)));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            )),
        backgroundColor: const Color(0xFF0081CF),
      ),
      backgroundColor: Colors.white,
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
                  const Row(children: [
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
                  (users == null ||
                          users!.isEmpty ||
                          (users!.length == 1 && users![0].userId == userId))
                      ? Container(
                          alignment: Alignment.center,
                          child: const AutoSizeText(
                            "Désolé, il n'y a que vous qui est intéressé pour l'instant",
                            minFontSize: 10,
                            maxFontSize: 12,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(0, 0, 0, 0.7)),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 10.0,
                              runSpacing: 20.0,
                              alignment: WrapAlignment.start,
                              children: List.generate(users!.length, (index) {
                                return FutureBuilder(
                                    future: Future.wait(
                                        [getUser(), getUsersImages(index)]),
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

                                      var image =
                                          snapshot.data![1] as UsersImages;
                                      var user = snapshot.data![0] as User;

                                      connectedUserPlan = user.plan!;

                                      return users![index].userId != userId
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    FadePageRoute(
                                                        page: ShowProfilePage(
                                                      showButton: false,
                                                      userId: widget
                                                          .users![index].userId,
                                                      showComment: false,
                                                      showMessage: false,
                                                    )));
                                              },
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.6,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.1),
                                                    image: image.userImages
                                                                .length !=
                                                            0
                                                        ? DecorationImage(
                                                            image: NetworkImage(
                                                                image
                                                                    .userImages[
                                                                        0]
                                                                    .image),
                                                            fit: BoxFit.cover)
                                                        : DecorationImage(
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .linearToSrgbGamma(),
                                                            image: NetworkImage(
                                                                "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                                            fit: BoxFit.contain,
                                                            alignment: Alignment
                                                                .bottomCenter),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  bottom: 10),
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child:
                                                                  AutoSizeText(
                                                                "${toBeginningOfSentenceCase(users![index].firstName)!}, ${users![index].age}",
                                                                minFontSize: 16,
                                                                maxFontSize: 17,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                    shadows: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black,
                                                                        blurRadius:
                                                                            10.0,
                                                                        spreadRadius:
                                                                            5.0,
                                                                        offset:
                                                                            Offset(
                                                                          0.0,
                                                                          0.0,
                                                                        ),
                                                                      )
                                                                    ]),
                                                              ))),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                                height: 40,
                                                                child:
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.push(
                                                                              context,
                                                                              FadePageRoute(
                                                                                  page: ShowProfilePage(
                                                                                showButton: false,
                                                                                userId: users![index].userId.toString(),
                                                                                showComment: false,
                                                                                showMessage: false,
                                                                              )));
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: const Color.fromRGBO(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0.5),
                                                                            shape:
                                                                                const RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), topRight: Radius.circular(20)))),
                                                                        child: const Icon(
                                                                          Icons
                                                                              .person,
                                                                          color:
                                                                              Colors.white,
                                                                        ))),
                                                            Container(
                                                                height: 40,
                                                                child:
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          var requestCount = await RequestsMessageService().getAllRequestsMessagesByUser(
                                                                              token.toString(),
                                                                              users![index].userId);

                                                                          if (requestCount.requestsMessages.length ==
                                                                              0) {
                                                                            await RequestMessageService().sendRequest(
                                                                                token.toString(),
                                                                                userId.toString(),
                                                                                users![index].userId,
                                                                                "Viami",
                                                                                "Vous avez une nouvelle demande de message de ${toBeginningOfSentenceCase(users![index].firstName)}!",
                                                                                users![index].fcmToken);

                                                                            showAlertDialog(
                                                                                context,
                                                                                "Information",
                                                                                "Votre demande a été envoyée, veuillez patienter jusqu'à ce que l'utilisateur accepte votre demande. Il est également possible que l'utilisateur ne soit pas en mesure d'accepter votre demande. Dans ce cas, vous pouvez renvoyer une demande.",
                                                                                "OK");
                                                                          } else {
                                                                            if (requestCount.requestsMessages[requestCount.requestsMessages.length - 1].accept ==
                                                                                null) {
                                                                              showAlertDialog(context, "Information", "Votre demande n'a pas encore répondu, veuillez patienter jusqu'à ce que l'utilisateur accepte votre demande.", "OK");
                                                                            } else if (requestCount.requestsMessages[requestCount.requestsMessages.length - 1].accept ==
                                                                                0) {
                                                                              await RequestMessageService().sendRequest(token.toString(), userId.toString(), users![index].userId, "Viami", "Vous avez une nouvelle demande de message ${toBeginningOfSentenceCase(users![index].firstName)}!", users![index].fcmToken);

                                                                              showAlertDialog(context, "Information", "Votre demande a été envoyée, veuillez patienter jusqu'à ce que l'utilisateur accepte votre demande. Il est également possible que l'utilisateur ne soit pas en mesure d'accepter votre demande. Dans ce cas, vous pouvez renvoyer une demande.", "OK");
                                                                            } else if (requestCount.requestsMessages[requestCount.requestsMessages.length - 1].accept ==
                                                                                1) {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  FadePageRoute(
                                                                                      page: const MenusPage(
                                                                                    currentIndex: 3,
                                                                                  )));
                                                                            }
                                                                          }
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: const Color.fromRGBO(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0.5),
                                                                            shape:
                                                                                const RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), topLeft: Radius.circular(20)))),
                                                                        child: const Icon(
                                                                          Icons
                                                                              .message_rounded,
                                                                          color:
                                                                              Colors.white,
                                                                        )))
                                                          ])
                                                    ],
                                                  )))
                                          : const SizedBox.shrink();
                                    });
                              }).toList()))
                ]))),
      ]),
    );
  }
}
