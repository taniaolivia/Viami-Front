import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/models-api/messenger/group_data.dart';
import 'package:viami/models-api/messenger/message.dart';
import 'package:viami/models-api/messenger/messages.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/services/message/message.service.dart';
import 'package:viami/services/message/messages.service.dart';

import 'package:viami/services/userImage/usersImages.service.dart';

import '../models-api/messenger/groups_data.dart';
import '../services/message/groups.service.dart';

class MessengerPage extends StatefulWidget {
  final String? userId;
  const MessengerPage({Key? key, this.userId}) : super(key: key);

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  int usersLength = 0;
  List userList = [];
  Messages? discussionMessages;

  Future<Groups> getAllDiscussionsForUser() {
    Future<Groups> getAllDiscussionsForUserById() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return GroupsService()
          .getAllDiscussionsForUser(token.toString(), userId.toString());
    }

    return getAllDiscussionsForUserById();
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

  Future<Messages> getDiscussionsForMessageWith(String messageId) async {
    token = await storage.read(key: "token");

    return await MessagesService().getDiscussionsForMessage(token!, messageId);
  }

  @override
  void initState() {
    super.initState();
    getAllDiscussionsForUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 40, 25, 60),
          child: FutureBuilder(
            future: getAllDiscussionsForUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('');
              }

              var messages = snapshot.data!;
              userList = [];

              List.generate(messages.groups.length, (index) {
                if (!userList
                    .contains(messages.groups[index].lastMessage.responderId)) {
                  userList.add(messages.groups[index].lastMessage.responderId);
                }
              });

              return Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: AutoSizeText(
                      "Messagerie",
                      minFontSize: 23,
                      maxFontSize: 25,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: List.generate(messages.groups.length, (index) {
                      return FutureBuilder(
                        future: Future.wait([
                          getUserImages(
                              messages.groups[index].lastMessage.senderId)
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return const Text('');
                          }

                          var message =
                              messages.groups[index].lastMessage as LastMessage;
                          var image = snapshot.data![0] as UsersImages;
                          bool isUserMessage = message.senderId == userId;
                          Color containerColor =
                              isUserMessage ? Colors.green : Colors.blue;

                          return GestureDetector(
                            onTap: () async {
                              var discussionMessages =
                                  await getDiscussionsForMessageWith(
                                messages.groups[index].lastMessage.id
                                    .toString(),
                              );

                              BuildContext currentContext = context;
                              showModalBottomSheet(
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  currentContext = context;

                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height -
                                                30,
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 8,
                                              width: 40,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                image.userImages.length != 0
                                                    ? CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                          image.userImages[0]
                                                              .image,
                                                        ),
                                                        maxRadius: 25,
                                                      )
                                                    : CircleAvatar(
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                220,
                                                                234,
                                                                250),
                                                        foregroundImage:
                                                            NetworkImage(
                                                          "${dotenv.env['CDN_URL']}/assets/noprofile.png",
                                                        ),
                                                        maxRadius: 25,
                                                      ),
                                                const SizedBox(width: 20),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.5,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color:
                                                            Color(0XFFE8E6EA),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: AutoSizeText(
                                                          toBeginningOfSentenceCase(
                                                            message
                                                                .senderLastName,
                                                          )!,
                                                          minFontSize: 10,
                                                          maxFontSize: 12,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.7,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child:
                                                                  AutoSizeText(
                                                                toBeginningOfSentenceCase(
                                                                  "status",
                                                                )!,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                minFontSize: 10,
                                                                maxFontSize: 12,
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          message.read == "0"
                                                              ? const Icon(
                                                                  Icons.circle,
                                                                  color: Color(
                                                                      0xFF0081CF),
                                                                  size: 12,
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: discussionMessages
                                                    .messages.length,
                                                itemBuilder: (context, index) {
                                                  var message =
                                                      discussionMessages
                                                          .messages[index];
                                                  bool isUserMessage =
                                                      message.senderId ==
                                                          userId;
                                                  Color containerColor =
                                                      isUserMessage
                                                          ? const Color(
                                                              0xFFF3F3F3)
                                                          : const Color(
                                                              0xFF0081CF);

                                                  DateTime messageDateTime =
                                                      DateTime.parse(
                                                          message.date);
                                                  DateTime now = DateTime.now();
                                                  bool isToday = messageDateTime
                                                              .year ==
                                                          now.year &&
                                                      messageDateTime.month ==
                                                          now.month &&
                                                      messageDateTime.day ==
                                                          now.day;

                                                  String formattedDate;

                                                  if (isToday) {
                                                    formattedDate =
                                                        DateFormat.jm().format(
                                                            messageDateTime);
                                                  } else {
                                                    formattedDate = DateFormat(
                                                            'EEE, MMM d, y, h:mm a')
                                                        .format(
                                                            messageDateTime);
                                                  }

                                                  return Align(
                                                    alignment: isUserMessage
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    child: ListTile(
                                                      title: Container(
                                                        margin: const EdgeInsets
                                                            .all(18),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(18),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: containerColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: AutoSizeText(
                                                          toBeginningOfSentenceCase(
                                                            message.message,
                                                          )!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          minFontSize: 10,
                                                          maxFontSize: 12,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      subtitle: Align(
                                                        alignment: isUserMessage
                                                            ? Alignment
                                                                .centerRight
                                                            : Alignment
                                                                .centerLeft,
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          child: Text(
                                                              formattedDate),
                                                        ),
                                                      ),
                                                      dense: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 8),
                                                      leading: isUserMessage
                                                          ? Container(
                                                              width: 48,
                                                              height: 48,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                            )
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                context: currentContext!,
                              );

                              await MessageService()
                                  .setMessageRead(token!, message.id);
                            },
                            child: Row(
                              children: [
                                image.userImages.length != 0
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          "${image.userImages[0].image}",
                                        ),
                                        maxRadius: 25,
                                      )
                                    : CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          220,
                                          234,
                                          250,
                                        ),
                                        foregroundImage: NetworkImage(
                                          "${dotenv.env['CDN_URL']}/assets/noprofile.png",
                                        ),
                                        maxRadius: 25,
                                      ),
                                const SizedBox(width: 20),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0XFFE8E6EA),
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: AutoSizeText(
                                          toBeginningOfSentenceCase(
                                            message.senderLastName,
                                          )!,
                                          minFontSize: 10,
                                          maxFontSize: 12,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: AutoSizeText(
                                                toBeginningOfSentenceCase(
                                                  message.message,
                                                )!,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 10,
                                                maxFontSize: 12,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          message.read == "0"
                                              ? const Icon(
                                                  Icons.circle,
                                                  color: Color(0xFF0081CF),
                                                  size: 12,
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
