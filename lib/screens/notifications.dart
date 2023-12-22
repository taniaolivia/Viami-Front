import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/models-api/requestMessage/requests_messages.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/services/requestMessage/request_message_service.dart';
import 'package:viami/services/requestMessage/requests_messages_service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final storage = const FlutterSecureStorage();
  String? token;
  String userImages = "";
  String? userId = "";
  bool? tokenExpired;
  RequestsMessages? requests;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");
      //bool isTokenExpired = AuthService().isTokenExpired(token!);

      //tokenExpired = isTokenExpired;

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  Future<UsersImages> getUsersImages(String userId) async {
    token = await storage.read(key: "token");

    return await UsersImagesService()
        .getUserImagesById(userId, token.toString());
  }

  Future<RequestsMessages> getAllRequestsByUser() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return RequestsMessageService()
        .getAllRequestsMessagesByUser(token.toString(), userId.toString());
  }

  void fetchData() {
    getUser();
    getAllRequestsByUser();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if (tokenExpired == true) {
      /*WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialogMessage(
            context,
            "Connectez-vous",
            const Text("Veuillez vous reconnecter !"),
            TextButton(
              child: const Text("Se connecter"),
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
            ),
            null);
      });*/
    }

    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'Demandes de message',
          minFontSize: 16,
          maxFontSize: 18,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home");
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
                margin: const EdgeInsets.fromLTRB(12, 20, 12, 50),
                child: FutureBuilder(
                    future: getAllRequestsByUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.2,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF0081CF)),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                        );
                      } else if (!snapshot.hasData) {
                        return const Text('');
                      }

                      requests = snapshot.data!;

                      return Column(
                          children: List.generate(
                              requests!.requestsMessages.length, (index) {
                        return FutureBuilder(
                            future: getUsersImages(
                                requests!.requestsMessages[index].requesterId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context)
                                            .size
                                            .height));
                              } else if (snapshot.hasError) {
                                return Text(
                                  '${snapshot.error}',
                                  textAlign: TextAlign.center,
                                );
                              } else if (!snapshot.hasData) {
                                return const Text('');
                              }

                              var image = snapshot.data!;

                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 90,
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Stack(children: [
                                    Positioned(
                                        left: 0,
                                        child: Container(
                                            height: 60,
                                            alignment: Alignment.centerLeft,
                                            child: Row(children: [
                                              image.userImages.length != 0
                                                  ? CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage:
                                                          AssetImage(image
                                                              .userImages[0]
                                                              .image),
                                                    )
                                                  : const CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              181, 181, 181),
                                                      child: Icon(Icons.person,
                                                          size: 40,
                                                          color: Colors.white)),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  height: 60,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: AutoSizeText(
                                                      "${toBeginningOfSentenceCase(requests!.requestsMessages[index].requesterFirstName)} ${toBeginningOfSentenceCase(requests!.requestsMessages[index].requesterLastName)}",
                                                      minFontSize: 16,
                                                      maxFontSize: 18,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600)))
                                            ]))),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Positioned(
                                        top: 5,
                                        right: 0,
                                        child: Container(
                                            width: 110,
                                            alignment: Alignment.centerRight,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .blue)),
                                                    onPressed: () async {
                                                      await RequestMessageService().answerRequest(
                                                          token!,
                                                          requests!
                                                              .requestsMessages[
                                                                  index]
                                                              .id,
                                                          1,
                                                          "Viami",
                                                          "${toBeginningOfSentenceCase(requests!.requestsMessages[index].receiverFirstName)} a accepté votre demande",
                                                          requests!
                                                              .requestsMessages[
                                                                  index]
                                                              .requesterFcmToken!);

                                                      var newRequestsList =
                                                          await getAllRequestsByUser();

                                                      setState(() {
                                                        requests =
                                                            newRequestsList;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.check,
                                                        size: 25,
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  IconButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .grey)),
                                                    onPressed: () async {
                                                      await RequestMessageService().answerRequest(
                                                          token!,
                                                          requests!
                                                              .requestsMessages[
                                                                  index]
                                                              .id,
                                                          1,
                                                          "Viami",
                                                          "${toBeginningOfSentenceCase(requests!.requestsMessages[index].receiverFirstName)} a refusé votre demande",
                                                          requests!
                                                              .requestsMessages[
                                                                  index]
                                                              .requesterFcmToken!);

                                                      var newRequestsList =
                                                          await getAllRequestsByUser();

                                                      setState(() {
                                                        requests =
                                                            newRequestsList;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.close,
                                                        size: 25,
                                                        color: Colors.white),
                                                  )
                                                ])))
                                  ]));
                            });
                      }).toList());
                    }))),
      ]),
    );
  }
}
