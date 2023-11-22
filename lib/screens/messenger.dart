import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/models-api/messenger/message.dart';
import 'package:viami/models-api/messenger/messages.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/services/message/message.service.dart';
import 'package:viami/services/message/messages.service.dart';

import 'package:viami/services/userImage/usersImages.service.dart';

class MessengerPage extends StatefulWidget {
  final String? userId;
  const MessengerPage({Key? key, this.userId}) : super(key: key);

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();

  String? token = "";
  String? userId = "";
  int usersLength = 0;
  List userList = [];
  List<String> previousUserList = [];

  Future<Messages> getAllMessages() {
    Future<Messages> getAllMessagesUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return MessagesService()
          .getAllMessagesBySender(token.toString(), userId.toString());
    }

    return getAllMessagesUser();
  }

  Future<Message> getLastMessageUsers(String responderId) async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return MessageService().getLastMessageTwoUsers(
        token.toString(), userId.toString(), responderId);
  }

  Future<UsersImages> getUserImages(String userId) async {
    token = await storage.read(key: "token");

    final images =
        await UsersImagesService().getUserImagesById(userId, token.toString());

    return images;
  }

  @override
  void initState() {
    super.initState();
    getAllMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.fromLTRB(25, 40, 25, 60),
              child: FutureBuilder(
                  future: getAllMessages(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('');
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Text('');
                    }

                    var messages = snapshot.data!;

                    List<String> updatedUserList = [];

                    List.generate(messages.messages.length, (index) {
                      if (!updatedUserList
                          .contains(messages.messages[index].responderId)) {
                        updatedUserList
                            .add(messages.messages[index].responderId);
                      }
                    });

                    if (userList.isEmpty) {
                      userList = updatedUserList;
                    }

                    return Column(children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: const AutoSizeText(
                            "Messagerie",
                            minFontSize: 23,
                            maxFontSize: 25,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Veuillez remplir votre email';
                                            }
                                            return null;
                                          },
                                          controller: searchController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                15, 5, 10, 5),
                                            labelText: 'Recherche',
                                            hintText: '',
                                            labelStyle: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ))),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0081CF),
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 12),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)))),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    var search = searchController.text;

                                    var userMessage = await MessagesService()
                                        .getSearchedUsers(
                                            token!, userId!, search);

                                    if (userMessage != null) {
                                      previousUserList = List.from(userList);
                                      updatedUserList = [];

                                      List.generate(userMessage.messages.length,
                                          (index) {
                                        if (!updatedUserList.contains(
                                            userMessage
                                                .messages[index].responderId)) {
                                          updatedUserList.add(userMessage
                                              .messages[index].responderId);
                                        }
                                      });

                                      setState(() {
                                        userList = updatedUserList;
                                      });
                                    }
                                  }
                                })
                          ])),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  userList = previousUserList;
                                  searchController.text = "";
                                });
                              },
                              child: const AutoSizeText(
                                "Réinitialiser",
                                minFontSize: 10,
                                maxFontSize: 12,
                              ))),
                      Column(
                          children: List.generate(userList.length, (index) {
                        return FutureBuilder(
                            future: Future.wait([
                              getLastMessageUsers(userList[index]),
                              getUserImages(userList[index])
                            ]),
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
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData) {
                                return const Text('');
                              }

                              var message = snapshot.data![0] as Message;
                              var image = snapshot.data![1] as UsersImages;

                              print(userList);
                              print(message.responderFirstName);

                              return GestureDetector(
                                  onTap: () async {
                                    await MessageService()
                                        .setMessageRead(token!, message.id);
                                  },
                                  child: Row(children: [
                                    image.userImages.length != 0
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "${image.userImages[0].image}"),
                                            maxRadius: 25,
                                          )
                                        : CircleAvatar(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 220, 234, 250),
                                            foregroundImage: NetworkImage(
                                                "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                            maxRadius: 25,
                                          ),
                                    const SizedBox(width: 20),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0XFFE8E6EA))),
                                        ),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 10),
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: AutoSizeText(
                                                      toBeginningOfSentenceCase(
                                                          message
                                                              .responderFirstName)!,
                                                      minFontSize: 10,
                                                      maxFontSize: 12,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              const SizedBox(height: 5),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.7,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: AutoSizeText(
                                                                toBeginningOfSentenceCase(
                                                                    message
                                                                        .message)!,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                minFontSize: 10,
                                                                maxFontSize: 12,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)))),
                                                    message.read == "0"
                                                        ? const Icon(
                                                            Icons.circle,
                                                            color: Color(
                                                                0xFF0081CF),
                                                            size: 12)
                                                        : Container()
                                                  ]),
                                              const SizedBox(height: 5),
                                            ])),
                                  ]));
                            });
                      }))
                    ]);
                  })),
        ));
  }
}
