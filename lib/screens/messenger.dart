import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/models-api/messenger/messages.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userGroup/groupUsers.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/services/groupUser/groupUsers.service..dart';
import 'package:viami/services/message/message.service.dart';
import 'package:viami/services/message/messages.service.dart';
import 'package:viami/services/user/user.service.dart';

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
  List groupList = [];
  List<String> previousUserList = [];
  List<int> previousGroupList = [];
  List<String> updatedUserList = [];
  List<int> updatedGroupList = [];
  List<String> messageList = [];

  Future<Messages> getAllMessages() {
    Future<Messages> getAllMessagesUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return MessagesService()
          .getAllMessagesBySender(token.toString(), userId.toString());
    }

    return getAllMessagesUser();
  }

  Future<Messages> getLastMessageUsers(String responderId) async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return MessagesService()
        .getLastMessageTwoUsers(token.toString(), userId.toString());
  }

  Future<UsersImages> getUserImages(String userId) async {
    token = await storage.read(key: "token");

    final images =
        await UsersImagesService().getUserImagesById(userId, token.toString());

    return images;
  }

  Future<GroupUsers> getGroupUsers(int groupId) async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return GroupUsersService()
        .getAllUsersGroup(token.toString(), groupId, userId.toString());
  }

  Future<User> getUserById(String userId) async {
    token = await storage.read(key: "token");

    return UserService().getUserById(userId, token.toString());
  }

  Future<void> fetchData() async {
    var messages = await getAllMessages();

    setState(() {
      List.generate(messages.messages.length, (index) {
        if (!updatedUserList.contains(messages.messages[index].responderId)) {
          updatedUserList.add(messages.messages[index].responderId!);
        }
      });

      List.generate(messages.messages.length, (index) {
        if (!groupList.contains(messages.messages[index].groupId)) {
          groupList.add(messages.messages[index].groupId);
        }
      });

      groupList.sort();

      if (userList.isEmpty) {
        userList = updatedUserList;
      }

      if (groupList.isEmpty) {
        groupList = updatedGroupList;
      }

      previousUserList = List.from(userList);
      previousGroupList = List.from(groupList);

      // Update the UI state with the new message lists
      //userList = updatedUserList;
      //groupList = updatedGroupList;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllMessages();
    fetchData();
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
                                      //previousUserList = List.from(userList);
                                      updatedUserList = [];
                                      updatedGroupList = [];
                                      messageList = [];

                                      List.generate(userMessage.messages.length,
                                          (index) {
                                        if (!updatedUserList.contains(
                                            userMessage
                                                .messages[index].responderId)) {
                                          updatedUserList.add(userMessage
                                              .messages[index].responderId!);
                                        }

                                        if (!updatedGroupList.contains(
                                            userMessage
                                                .messages[index].groupId)) {
                                          updatedGroupList.add(userMessage
                                              .messages[index].groupId);
                                        }

                                        if (!messageList.contains(userMessage
                                            .messages[index].message)) {
                                          messageList.add(userMessage
                                              .messages[index].message);
                                        }
                                      });

                                      setState(() {
                                        previousUserList = List.from(userList);
                                        previousGroupList =
                                            List.from(groupList);

                                        userList = updatedUserList;
                                        groupList = updatedGroupList;
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
                                  groupList = previousGroupList;
                                  messageList = [];

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
                              getLastMessageUsers(userId!),
                              getGroupUsers(groupList[index])
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

                              var messages = snapshot.data![0] as Messages;
                              var group = snapshot.data![1] as GroupUsers;

                              print(userList);
                              print(messageList);
                              List<String?> userNames =
                                  group.groupUsers.map((user) {
                                return toBeginningOfSentenceCase(
                                    user.firstName);
                              }).toList();

                              String allUsers = userNames.join(", ");

                              return GestureDetector(
                                  onTap: () async {
                                    await MessageService().setMessageRead(
                                        token!, messages.messages[index].id);
                                  },
                                  child: Row(children: [
                                    Container(
                                        width: 70,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Stack(
                                            children: List.generate(
                                                group.groupUsers.length,
                                                (groupIndex) {
                                          return FutureBuilder(
                                              future: getUserImages(group
                                                  .groupUsers[groupIndex]
                                                  .userId),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 5, sigmaY: 5),
                                                      child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height));
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else if (!snapshot.hasData) {
                                                  return const Text('');
                                                }

                                                var image = snapshot.data!;

                                                var avatar =
                                                    image.userImages.length != 0
                                                        ? CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    "${image.userImages[0].image}"),
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
                                                                    "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                                            maxRadius: 25,
                                                          );

                                                if (groupIndex < 2) {
                                                  if (group.groupUsers.length ==
                                                      1) {
                                                    return Positioned(
                                                      left: 10,
                                                      child: avatar,
                                                    );
                                                  } else {
                                                    return Positioned(
                                                      right: groupIndex
                                                              .toDouble() *
                                                          15,
                                                      child: avatar,
                                                    );
                                                  }
                                                } else if (groupIndex >= 2) {
                                                  return Positioned(
                                                    right: groupIndex < 2
                                                        ? groupIndex
                                                                .toDouble() *
                                                            15
                                                        : 0,
                                                    child: Stack(
                                                      children: [
                                                        avatar,
                                                        Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.blue,
                                                            child: Text(
                                                              '+${group.groupUsers.length - 2}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            maxRadius: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                return const SizedBox();
                                              });
                                        }))),
                                    const SizedBox(width: 20),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.7,
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        decoration: const BoxDecoration(
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
                                                  child: group.groupUsers
                                                              .length ==
                                                          1
                                                      ? AutoSizeText(
                                                          toBeginningOfSentenceCase(
                                                              group
                                                                  .groupUsers[0]
                                                                  .firstName)!,
                                                          minFontSize: 10,
                                                          maxFontSize: 12,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                      : Row(children: [
                                                          Container(
                                                              constraints: BoxConstraints(
                                                                  maxWidth: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      2),
                                                              child: AutoSizeText(
                                                                  allUsers,
                                                                  minFontSize:
                                                                      10,
                                                                  maxFontSize:
                                                                      12,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                          AutoSizeText(
                                                              ' (${group.groupUsers.length.toString()})',
                                                              minFontSize: 10,
                                                              maxFontSize: 12,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ])),
                                              const SizedBox(height: 5),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        width: MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.9,
                                                        child: messageList.isNotEmpty
                                                            ? Align(
                                                                alignment: Alignment
                                                                    .topLeft,
                                                                child: AutoSizeText(messageList[index],
                                                                    overflow: TextOverflow
                                                                        .ellipsis,
                                                                    minFontSize:
                                                                        10,
                                                                    maxFontSize:
                                                                        12,
                                                                    style: const TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .w500)))
                                                            : Align(
                                                                alignment: Alignment
                                                                    .topLeft,
                                                                child: AutoSizeText(
                                                                    groupList[index] == messages.messages[index].groupId
                                                                        ? messages.messages[index].message
                                                                        : "",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    minFontSize: 10,
                                                                    maxFontSize: 12,
                                                                    style: const TextStyle(fontWeight: FontWeight.w500)))),
                                                    messages.messages[index]
                                                                .read ==
                                                            "0"
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
