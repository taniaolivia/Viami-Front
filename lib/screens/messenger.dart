import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
import '../models-api/travel/travels.dart';
import '../models-api/userStatus/userStatus.dart';
import '../services/message/groups.service.dart';
import '../services/travel/travels.service.dart';
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

  String? token = "";
  String? userId = "";
  int usersLength = 0;
  List userList = [];
  Groups? discussionMessages;
  Color groupButtonColor = Colors.white;
  Color groupTextColor = Colors.black;
  Color seulButtonColor = Colors.white;
  Color seulTextColor = Colors.black;
  String filterSeulGroup = "all";
  String? selectedLocation;
  List locationList = [""];

  Future<Travels> getListTravels() {
    Future<Travels> getAllTravels() async {
      token = await storage.read(key: "token");

      return TravelsService().getAllTravels(token.toString());
    }

    return getAllTravels();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");
    await updateLocationList();
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

  Future<Groups> getAllDiscussionsForUserByLocation(String location) {
    return GroupsService()
        .getGroupUsersDiscussionsByLocation(token!, userId!, location);
  }

  Future<void> getDiscussionsByFilter() async {
    switch (filterSeulGroup) {
      case "seul":
        discussionMessages = await getAllDiscussionsForTwoUser();
        break;
      case "group":
        discussionMessages = await getAllDiscussionsForGroupUser();
        break;
      case "location":
        if (selectedLocation != null && selectedLocation!.isNotEmpty) {
          discussionMessages =
              await getAllDiscussionsForUserByLocation(selectedLocation!);
        }
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

  Future<UserStatus> getUserStatusById(String travelerId) async {
    token = await storage.read(key: "token");

    return await UserStatusService().getUserStatusById(travelerId, token!);
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

  Future<void> updateLocationList() async {
    var travels = await getListTravels();

    setState(() {
      locationList.clear();
      for (int i = 0; i < travels.travels.length; i++) {
        if (!locationList.contains(travels.travels[i].location)) {
          locationList.add(travels.travels[i].location);
        }
      }
    });
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

                        return GestureDetector(
                          onTap: () async {},
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
                                width: MediaQuery.of(context).size.width / 1.5,
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
                                          message.senderFirstName,
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
                  ),
                  Form(
                      key: _formKey,
                      child: Column(children: [
                        Row(children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: DropdownButtonFormField<String>(
                                  menuMaxHeight: 130,
                                  value: selectedLocation,
                                  hint: const Text("Destination*"),
                                  onChanged: (value) => setState(() {
                                        selectedLocation = value;
                                        filterSeulGroup = "location";
                                      }),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez choisir votre destination';
                                    }
                                    return null;
                                  },
                                  items: locationList
                                      .map<DropdownMenuItem<String>>(
                                          (dynamic value) {
                                    return DropdownMenuItem<String>(
                                      value: value.toString(),
                                      child: Text(value.toString()),
                                    );
                                  }).toList())),
                        ]),
                        ElevatedButton(
                          onPressed: () async {
                            if (selectedLocation != null &&
                                selectedLocation!.isNotEmpty) {
                              setState(() => filterSeulGroup = "location");
                            }

                            await getDiscussionsByFilter();
                            Navigator.pop(context);
                          },
                          child: const Text("Appliquer le filtre"),
                        ),
                      ]))
                ],
              ),
            );
          },
        );
      },
    );
  }
}
