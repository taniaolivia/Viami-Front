import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/models-api/messenger/group_data.dart';
import 'package:viami/models-api/messenger/messages.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/services/message/messages.service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';
import '../models-api/messenger/groups_data.dart';
import '../models-api/userStatus/userStatus.dart';
import '../services/message/groups.service.dart';
import '../services/userStatus/userStatus.service.dart';

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

  Groups? discussionMessages;
  Color groupButtonColor = Colors.white;
  Color groupTextColor = Colors.black;
  Color seulButtonColor = Colors.white;
  Color seulTextColor = Colors.black;
  String filterSeulGroup = "all";

  Future<void> fetchData() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");
    await getDiscussionsByFilter();
  }

  Future<Groups> getAllDiscussionsForUser() {
    return GroupsService().getAllDiscussionsForUser(token!, userId!);
  }

  Future<Groups> getAllDiscussionsForTwoUser() {
    return GroupsService().getTwoUserDiscussions(token!, userId!);
  }

  Future<Groups> getAllDiscussionsForGroupUser() {
    return GroupsService().getGroupUsersDiscussions(token!, userId!);
  }

  Future<void> getDiscussionsByFilter() async {
    switch (filterSeulGroup) {
      case "seul":
        discussionMessages = await getAllDiscussionsForTwoUser();
        break;
      case "group":
        discussionMessages = await getAllDiscussionsForGroupUser();
        break;
      default:
        discussionMessages = await getAllDiscussionsForUser();
        break;
    }
    // Refresh the widget
    if (mounted) {
      setState(() {});
    }
  }

  Future<UsersImages> getUserImages(String userId) async {
    token = await storage.read(key: "token");

    final images =
        await UsersImagesService().getUserImagesById(userId, token.toString());

    return images;
  }

  Future<User> getUserById(String userId) async {
    token = await storage.read(key: "token");

    return UserService().getUserById(userId, token.toString());
  }

  Future<Messages> getDiscussionsForMessageWith(String messageId) async {
    token = await storage.read(key: "token");

    return await MessagesService().getDiscussionsForMessage(token!, messageId);
  }

  Future<UserStatus> getUserStatusById(String travelerId) async {
    token = await storage.read(key: "token");

    return await UserStatusService().getUserStatusById(travelerId, token!);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    clearFilters();
  }

  void clearFilters() {
    setState(() {
      seulButtonColor = Colors.white;
      seulTextColor = Colors.black;
      groupButtonColor = Colors.white;
      groupTextColor = Colors.black;
      filterSeulGroup = "all";
    });
    getDiscussionsByFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 40, 25, 60),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        _showFiltersBottomSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Icon(
                          Icons.filter_list,
                          size: 20.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez remplir votre email';
                                    }
                                    return null;
                                  },
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 5, 10, 5),
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
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var search = searchController.text;

                            var userMessage = await GroupsService()
                                .getSearchedUsers(token!, userId!, search);

                            if (userMessage != null) {
                              setState(() {
                                discussionMessages = userMessage;
                              });
                            }
                          }
                        })
                  ])),
              Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () async {
                        var clear = await getAllDiscussionsForUser();

                        setState(() {
                          discussionMessages = clear;
                          searchController.text = "";
                        });
                      },
                      child: const AutoSizeText(
                        "Réinitialiser",
                        minFontSize: 10,
                        maxFontSize: 12,
                      ))),
              Column(
                children: List.generate(
                  discussionMessages?.groups.length ?? 0,
                  (index) {
                    return FutureBuilder(
                      future: Future.wait([
                        getUserImages(discussionMessages
                                ?.groups[index].lastMessage.senderId ??
                            "")
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

                        var message = discussionMessages
                            ?.groups[index].lastMessage as LastMessage;
                        var image = snapshot.data![0] as UsersImages;

                        bool isUserMessage = message.senderId == userId;
                        Color containerColor =
                            isUserMessage ? Colors.green : Colors.blue;

                        List<UserData> users =
                            discussionMessages!.groups[index].users;

                        List<String?> userNames = users.map((user) {
                          return toBeginningOfSentenceCase(user.firstName);
                        }).toList();

                        List<String?> userIds = users.map((user) {
                          return user.id;
                        }).toList();

                        String allUsers = userNames.join(", ");

                        return GestureDetector(
                          onTap: () async {
                            /*await MessageService().setMessageRead(
                                token!, messages.messages[index].id);*/
                          },
                          child: Row(
                            children: [
                              Container(
                                  width: 70,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Stack(
                                      children: List.generate(users.length,
                                          (userIndex) {
                                    return FutureBuilder(
                                        future:
                                            getUserImages(userIds[userIndex]!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 5, sigmaY: 5),
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
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
                                                      backgroundImage: NetworkImage(
                                                          "${image.userImages[0].image}"),
                                                      maxRadius: 25,
                                                    )
                                                  : CircleAvatar(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              220,
                                                              234,
                                                              250),
                                                      foregroundImage: NetworkImage(
                                                          "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                                      maxRadius: 25,
                                                    );

                                          if (userIndex < 2) {
                                            if (users.length == 1) {
                                              return Positioned(
                                                left: 10,
                                                child: avatar,
                                              );
                                            } else {
                                              return Positioned(
                                                right:
                                                    userIndex.toDouble() * 15,
                                                child: avatar,
                                              );
                                            }
                                          } else if (userIndex >= 2) {
                                            return Positioned(
                                              right: userIndex < 2
                                                  ? userIndex.toDouble() * 15
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
                                                      maxRadius: 15,
                                                      child: Text(
                                                        '+${users.length - 2}',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
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
                                width: MediaQuery.of(context).size.width / 1.7,
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Color(0XFFE8E6EA))),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(children: [
                                          Container(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2),
                                              child: AutoSizeText(allUsers,
                                                  minFontSize: 10,
                                                  maxFontSize: 12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          users.length > 1
                                              ? AutoSizeText(
                                                  " (${users.length.toString()})",
                                                  minFontSize: 10,
                                                  maxFontSize: 12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                              : const SizedBox.shrink(),
                                        ])),
                                    const SizedBox(height: 5),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.9,
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: AutoSizeText(
                                                      message.message,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize: 10,
                                                      maxFontSize: 12,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .w500)))),
                                          message.read == "0"
                                              ? const Icon(Icons.circle,
                                                  color: Color(0xFF0081CF),
                                                  size: 12)
                                              : Container()
                                        ]),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 8,
                    width: 40,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AutoSizeText(
                        "Filters",
                        minFontSize: 22,
                        maxFontSize: 24,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          clearFilters();
                          Navigator.pop(context);
                        },
                        child: const AutoSizeText(
                          "Clear",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: const [
                      AutoSizeText(
                        "Voir que les conversation ",
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontFamily: "Poppins",
                        ),
                        minFontSize: 20,
                        maxFontSize: 22,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                seulButtonColor = Colors.blue;
                                seulTextColor = Colors.white;
                                groupButtonColor = Colors.white;
                                groupTextColor = Colors.black;
                                filterSeulGroup = "seul";
                              });
                              await getDiscussionsByFilter();
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: seulButtonColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Seul',
                                  style: TextStyle(
                                    color: seulTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                groupButtonColor = Colors.blue;
                                groupTextColor = Colors.white;
                                seulButtonColor = Colors.white;
                                seulTextColor = Colors.black;
                                filterSeulGroup = "group";
                              });
                              await getDiscussionsByFilter();
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: groupButtonColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Group',
                                  style: TextStyle(
                                    color: groupTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
