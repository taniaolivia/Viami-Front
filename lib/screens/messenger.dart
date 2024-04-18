import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:viami/components/users_no_discussion.dart';
import 'package:viami/models-api/messenger/group_data.dart';
import 'package:viami/models-api/messenger/messages.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/screens/payment.dart';
import 'package:viami/screens/showProfile.dart';
import 'package:viami/services/message/message.service.dart';
import 'package:viami/services/message/messages.service.dart';
import 'package:viami/services/user-premium-plan/user_premium_plan_service.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/user/users.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';
import 'package:viami/models-api/messenger/groups_data.dart';
import 'package:viami/models-api/userStatus/userStatus.dart';
import 'package:viami/services/message/groups.service.dart';
import 'package:viami/services/userStatus/userStatus.service.dart';
import 'package:viami/models-api/travel/travels.dart';
import 'package:viami/services/travel/travels.service.dart';
import '../components/myCustomDialog.dart';
import '../models-api/user/users.dart';
import '../components/pageTransition.dart';

class MessengerPage extends StatefulWidget {
  final String? userId;
  const MessengerPage({Key? key, this.userId}) : super(key: key);

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _formKeySearch = GlobalKey<FormState>();
  late IO.Socket socket;

  ScrollController _scrollController = ScrollController();

  TextEditingController searchController = TextEditingController();
  TextEditingController _textController = TextEditingController();
  bool _isKeyboardVisible = false;

  String? token = "";
  String? userId = "";

  Groups? discussionMessages;
  Messages? discussion;

  int? userCount;
  int userMessagesCount = 0;

  Color groupButtonColor = Colors.white;
  Color groupTextColor = Colors.black;
  Color seulButtonColor = Colors.white;
  Color seulTextColor = Colors.black;
  Color unreadButtonColor = Colors.white;
  Color unreadTextColor = Colors.black;
  Color readButtonColor = Colors.white;
  Color readTextColor = Colors.black;

  String filterSeulGroup = "all";
  String? selectedLocation;
  List locationList = [""];
  bool showPremium = false;

  Future<Travels> getListTravels() {
    Future<Travels> getAllTravels() async {
      token = await storage.read(key: "token");

      return TravelsService().getAllTravels(token.toString());
    }

    return getAllTravels();
  }

  Future<void> fetchData() async {
    await updateLocationList();
    await getDiscussionsByFilter();
    var messageCount = await MessagesService()
        .getAllMessagesByUserId(token.toString(), userId.toString());

    setState(() {
      userMessagesCount = messageCount;
    });
  }

  Future<Groups> getAllDiscussionsForUser() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return GroupsService().getAllDiscussionsForUser(token!, userId!);
  }

  Future<Groups> getAllDiscussionsForTwoUser() {
    return GroupsService().getTwoUserDiscussions(token!, userId!);
  }

  Future<Groups> getAllDiscussionsForGroupUser() {
    return GroupsService().getGroupUsersDiscussions(token!, userId!);
  }

  Future<Groups> getAllDiscussionsByUnreadFilter() {
    return GroupsService().getUsersDiscussionsByUnReadFilter(token!, userId!);
  }

  Future<Groups> getAllDiscussionsByReadFilter() {
    return GroupsService().getUsersDiscussionsByReadFilter(token!, userId!);
  }

  Future<Groups> getAllDiscussionsForUserByLocation(String location) {
    return GroupsService()
        .getGroupUsersDiscussionsByLocation(token!, userId!, location);
  }

  Future<void> send(int? groupId, String message, String? responderId) async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");
    // Envoyez le message à l'aide de l'ID de discussion
    var messageData = {
      'text': message,
      'discussionId': groupId.toString(),
    };

    // Envoyez le message au serveur
    socket.emit('chat message', messageData);
    var newDisc = await MessagesService()
        .getDiscussionsForGroup(token.toString(), groupId.toString());
    setState(() {
      discussion = newDisc;
    });

    _textController.clear();

    Timer(
        const Duration(milliseconds: 300),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));

    return MessageService()
        .sendMessage(token.toString(), groupId, message, userId, responderId);
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
      case "nonLu":
        discussionMessages = await getAllDiscussionsByUnreadFilter();

        break;
      case "lu":
        discussionMessages = await getAllDiscussionsByReadFilter();

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

  Future<Users> getAllUsers() async {
    token = await storage.read(key: "token");
    final allUsers = await UsersService().getAllUsers(token.toString());

    return allUsers;
  }

  Future<User> getUserById(String userId) async {
    token = await storage.read(key: "token");

    return UserService().getUserById(userId, token.toString());
  }

  Future<Messages> getDiscussionsForMessageWith(String messageId) async {
    token = await storage.read(key: "token");

    return await MessagesService().getDiscussionsForMessage(token!, messageId);
  }

  Future<UserStatus> getUserStatusById(String? travelerId) async {
    token = await storage.read(key: "token");

    return await UserStatusService().getUserStatusById(travelerId!, token!);
  }

  void _handleSubmitted(String text) {
    _textController.clear();
  }

  @override
  void dispose() {
    // Disconnect from the Socket.IO server when the widget is destroyed
    socket.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    fetchData();
    clearFilters();
    // Connect to the Socket.IO server
    socket = IO.io('${dotenv.env['SO_URL']}');
    socket.connect();

    // Listen for 'chat message' events for real-time updates
    socket.on('chat message', (data) {
      // Refresh the discussion when a new message is received
      //refreshDiscussion();
    });

    _scrollController.addListener(() {
      final isKeyboardVisible = _scrollController.position.maxScrollExtent > 0;
      if (isKeyboardVisible != _isKeyboardVisible) {
        setState(() {
          _isKeyboardVisible = isKeyboardVisible;
        });
      }
    });
    super.initState();
  }

  void clearFilters() {
    getDiscussionsByFilter();

    setState(() {
      seulButtonColor = Colors.white;
      seulTextColor = Colors.black;
      groupButtonColor = Colors.white;
      groupTextColor = Colors.black;
      filterSeulGroup = "all";
    });
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
    void scrollToBottom() {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 70, 25, 60),
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
                        child: const Icon(
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
                            key: _formKeySearch,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez remplir un prénom';
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
                                    labelText: 'Recherche par prénom',
                                    hintText: '',
                                    labelStyle: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ))),
                    const SizedBox(
                      width: 5,
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
                          if (_formKeySearch.currentState!.validate()) {
                            var search = searchController.text;

                            var userMessage = await GroupsService()
                                .getSearchedUsers(token!, userId!, search);

                            if (userMessage != null) {
                              setState(() {
                                discussionMessages = userMessage;
                              });
                            }

                            FocusScope.of(context).unfocus();
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

                        FocusScope.of(context).unfocus();
                      },
                      child: const AutoSizeText(
                        "Réinitialiser",
                        minFontSize: 10,
                        maxFontSize: 12,
                        style: TextStyle(color: Color(0xFF0081CF)),
                      ))),
              const UsersNoDiscussionPage(),
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
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2,
                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5)),
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                            '',
                            textAlign: TextAlign.center,
                          );
                        } else if (!snapshot.hasData) {
                          return const Text('');
                        }

                        var message = discussionMessages
                            ?.groups[index].lastMessage as LastMessage;

                        bool isUserMessage = message.senderId == userId;
                        Color containerColor = isUserMessage
                            ? Colors.green
                            : Color.fromARGB(255, 174, 218, 254);

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
                            discussion = await getDiscussionsForMessageWith(
                              discussionMessages!.groups[index].lastMessage.id
                                  .toString(),
                            );
                            var status = await getUserStatusById(
                                discussionMessages
                                    ?.groups[index].lastMessage.senderId);

                            setState(() {
                              clearFilters();
                            });

                            var plan = await UserPremiumPlansService()
                                .getUserPremiumPlan(
                                    token.toString(), userId.toString());

                            if (plan != null) {
                              var tokenExpired =
                                  AuthService().isTokenExpired(plan.token);

                              if (tokenExpired) {
                                await UserService().updateUserPlanById(
                                    userId.toString(),
                                    "free",
                                    token.toString());
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

                            BuildContext currentContext = context;
                            showModalBottomSheet(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                              ),
                              builder: (context) {
                                currentContext = context;

                                Timer(
                                    const Duration(milliseconds: 100),
                                    () => _scrollController.jumpTo(
                                        _scrollController
                                            .position.maxScrollExtent));

                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10, left: 20),
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.3,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30),
                                          ),
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
                                                Container(
                                                    width: 70,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    color: Colors.white,
                                                    child: Stack(
                                                        children: List.generate(
                                                            users.length,
                                                            (userIndex) {
                                                      return FutureBuilder(
                                                          future: getUserImages(
                                                              userIds[
                                                                  userIndex]!),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    2,
                                                                child: BackdropFilter(
                                                                    filter: ImageFilter.blur(
                                                                        sigmaX:
                                                                            5,
                                                                        sigmaY:
                                                                            5)),
                                                              );
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  '${snapshot.error}');
                                                            } else if (!snapshot
                                                                .hasData) {
                                                              return const Text(
                                                                  '');
                                                            }

                                                            var image =
                                                                snapshot.data!;

                                                            var avatar = image
                                                                        .userImages
                                                                        .length !=
                                                                    0
                                                                ? GestureDetector(
                                                                    onTap: () =>
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          FadePageRoute(
                                                                              page: ShowProfilePage(
                                                                            showButton:
                                                                                false,
                                                                            userId:
                                                                                message.senderId,
                                                                            showComment:
                                                                                true,
                                                                            showMessage:
                                                                                false,
                                                                          )),
                                                                        ),
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              "${image.userImages[0].image}"),
                                                                      maxRadius:
                                                                          25,
                                                                    ))
                                                                : GestureDetector(
                                                                    onTap: () =>
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          FadePageRoute(
                                                                              page: ShowProfilePage(
                                                                            showButton:
                                                                                false,
                                                                            userId:
                                                                                message.senderId,
                                                                            showComment:
                                                                                true,
                                                                            showMessage:
                                                                                false,
                                                                          )),
                                                                        ),
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          220,
                                                                          234,
                                                                          250),
                                                                      foregroundImage:
                                                                          NetworkImage(
                                                                              "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                                                      maxRadius:
                                                                          25,
                                                                    ));

                                                            if (userIndex < 2) {
                                                              if (users
                                                                      .length ==
                                                                  1) {
                                                                return Positioned(
                                                                  left: 10,
                                                                  child: avatar,
                                                                );
                                                              } else {
                                                                return Positioned(
                                                                  right: userIndex
                                                                          .toDouble() *
                                                                      15,
                                                                  child: avatar,
                                                                );
                                                              }
                                                            } else if (userIndex >=
                                                                2) {
                                                              return Positioned(
                                                                right: userIndex <
                                                                        2
                                                                    ? userIndex
                                                                            .toDouble() *
                                                                        15
                                                                    : 0,
                                                                child: Stack(
                                                                  children: [
                                                                    avatar,
                                                                    Positioned(
                                                                      bottom: 0,
                                                                      left: 0,
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundColor:
                                                                            Colors.blue,
                                                                        maxRadius:
                                                                            15,
                                                                        child:
                                                                            Text(
                                                                          '+${users.length - 2}',
                                                                          style: const TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold),
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.0,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
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
                                                          allUsers,
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
                                                                2,
                                                            child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Row(
                                                                  children: [
                                                                    status.status ==
                                                                            "online"
                                                                        ? const Icon(
                                                                            Icons.circle,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                0,
                                                                                207,
                                                                                62),
                                                                            size:
                                                                                10,
                                                                          )
                                                                        : const Text(
                                                                            ""),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    AutoSizeText(
                                                                      status.status ==
                                                                              "online"
                                                                          ? toBeginningOfSentenceCase(
                                                                              "en ligne",
                                                                            )!
                                                                          : toBeginningOfSentenceCase(
                                                                              "hors ligne",
                                                                            )!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      minFontSize:
                                                                          10,
                                                                      maxFontSize:
                                                                          12,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                !showPremium
                                                    ? Builder(builder:
                                                        (BuildContext context) {
                                                        return PopupMenuButton<
                                                            String>(
                                                          child: Container(
                                                            height: 10,
                                                            width: 50,
                                                            child: const Icon(
                                                              Icons.more_vert,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          onSelected:
                                                              (value) async {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                var groupeIdPass =
                                                                    discussionMessages!
                                                                        .groups[
                                                                            index]
                                                                        .lastMessage
                                                                        .groupId;

                                                                return MyCustomDialog(
                                                                  groupId:
                                                                      groupeIdPass,
                                                                );
                                                              },
                                                            );
                                                          },
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context) =>
                                                                  <PopupMenuEntry<
                                                                      String>>[
                                                            const PopupMenuItem<
                                                                String>(
                                                              value:
                                                                  'ajouterVoyageur',
                                                              child: ListTile(
                                                                leading: Icon(
                                                                    color: Colors
                                                                        .black,
                                                                    Icons
                                                                        .person_add),
                                                                title: Text(
                                                                    'Ajouter un voyageur'),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      })
                                                    : Container()
                                                ////
                                              ],
                                            ),
                                            Divider(
                                                thickness: 1,
                                                height: 2,
                                                color: Color(0XFFE8E6EA)),
                                            Expanded(
                                              child: ListView.builder(
                                                controller: _scrollController,
                                                itemCount:
                                                    discussion?.messages.length,
                                                itemBuilder: (context, index) {
                                                  var message = discussion
                                                      ?.messages[index];
                                                  bool isUserMessage =
                                                      message?.senderId ==
                                                          userId;
                                                  Color containerColor =
                                                      isUserMessage
                                                          ? const Color
                                                              .fromARGB(255,
                                                              195, 226, 245)
                                                          : const Color(
                                                              0xFFF3F3F3);

                                                  DateTime messageDateTime =
                                                      DateTime.parse(
                                                          message!.date);
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
                                                    formattedDate = DateFormat(
                                                            'HH:mm', "fr_FR")
                                                        .format(
                                                            messageDateTime);
                                                  } else {
                                                    formattedDate = DateFormat(
                                                            'dd/MM/y, HH:mm',
                                                            "fr_FR")
                                                        .format(
                                                            messageDateTime);
                                                  }

                                                  return Align(
                                                    alignment: isUserMessage
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    child: ListTile(
                                                      title: Container(
                                                        margin: isUserMessage
                                                            ? const EdgeInsets
                                                                .all(0)
                                                            : const EdgeInsets
                                                                .only(
                                                                right: 35),
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
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            if (message
                                                                    .senderId !=
                                                                userId)
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10),
                                                                width: 40,
                                                                height: 40,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                child:
                                                                    FutureBuilder(
                                                                  future: getUserImages(
                                                                      message
                                                                          .senderId),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting) {
                                                                      return Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        height:
                                                                            MediaQuery.of(context).size.height /
                                                                                2,
                                                                        child: BackdropFilter(
                                                                            filter:
                                                                                ImageFilter.blur(sigmaX: 5, sigmaY: 5)),
                                                                      );
                                                                    } else if (snapshot
                                                                        .hasError) {
                                                                      return Text(
                                                                          '${snapshot.error}');
                                                                    } else if (!snapshot
                                                                            .hasData ||
                                                                        snapshot
                                                                            .data!
                                                                            .userImages
                                                                            .isEmpty) {
                                                                      return GestureDetector(
                                                                        onTapDown:
                                                                            (TapDownDetails
                                                                                details) async {
                                                                          final RenderBox
                                                                              overlay =
                                                                              Overlay.of(context)!.context.findRenderObject() as RenderBox;
                                                                          final RelativeRect
                                                                              position =
                                                                              RelativeRect.fromRect(
                                                                            details.globalPosition &
                                                                                const Size(40, 40),
                                                                            overlay.localToGlobal(Offset.zero) &
                                                                                overlay.size,
                                                                          );

                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            FadePageRoute(
                                                                                page: ShowProfilePage(
                                                                              showButton: false,
                                                                              userId: message.senderId,
                                                                              showComment: true,
                                                                              showMessage: false,
                                                                            )),
                                                                          );
                                                                          /*inal String?
                                                                              choice =
                                                                              await showMenu<String>(
                                                                            context:
                                                                                context,
                                                                            position:
                                                                                position,
                                                                            items: [
                                                                              const PopupMenuItem<String>(
                                                                                value: 'go_to_profile',
                                                                                child: Text('Voir le profil'),
                                                                              ),
                                                                            ],
                                                                          );*/

                                                                          /*if (choice ==
                                                                              'go_to_profile') {
                                                                            Navigator.push(
                                                                              context,
                                                                              FadePageRoute(
                                                                                  page: ShowProfilePage(
                                                                                showButton: false,
                                                                                userId: message.senderId,
                                                                                showComment: true,
                                                                              )),
                                                                            );
                                                                          }*/
                                                                        },
                                                                        child:
                                                                            CircleAvatar(
                                                                          backgroundColor: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              220,
                                                                              234,
                                                                              250),
                                                                          foregroundImage:
                                                                              NetworkImage("${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                                                          maxRadius:
                                                                              1,
                                                                        ),
                                                                      );
                                                                    }
                                                                    var image =
                                                                        snapshot
                                                                            .data!;

                                                                    var avatar =
                                                                        GestureDetector(
                                                                      onTapDown:
                                                                          (TapDownDetails
                                                                              details) async {
                                                                        final RenderBox
                                                                            overlay =
                                                                            Overlay.of(context)!.context.findRenderObject()
                                                                                as RenderBox;
                                                                        final RelativeRect
                                                                            position =
                                                                            RelativeRect.fromRect(
                                                                          details.globalPosition &
                                                                              const Size(40, 40),
                                                                          overlay.localToGlobal(Offset.zero) &
                                                                              overlay.size,
                                                                        );

                                                                        /*final String?
                                                                            choice =
                                                                            await showMenu<String>(
                                                                          context:
                                                                              context,
                                                                          position:
                                                                              position,
                                                                          items: [
                                                                            const PopupMenuItem<String>(
                                                                              value: 'go_to_profile',
                                                                              child: Text('Voir le profil'),
                                                                            ),
                                                                          ],
                                                                        );*/

                                                                        /*if (choice ==
                                                                            'go_to_profile') {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            FadePageRoute(
                                                                                page: ShowProfilePage(
                                                                              showButton: false,
                                                                              userId: message.senderId,
                                                                              showComment: true,
                                                                            )),
                                                                          );
                                                                        }*/

                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          FadePageRoute(
                                                                              page: ShowProfilePage(
                                                                            showButton:
                                                                                false,
                                                                            userId:
                                                                                message.senderId,
                                                                            showComment:
                                                                                true,
                                                                            showMessage:
                                                                                false,
                                                                          )),
                                                                        );
                                                                      },
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundImage:
                                                                            NetworkImage("${image.userImages[0].image}"),
                                                                        maxRadius:
                                                                            15,
                                                                      ),
                                                                    );

                                                                    return avatar;
                                                                  },
                                                                ),
                                                              ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  if (message
                                                                          .senderId !=
                                                                      userId)
                                                                    AutoSizeText(
                                                                      toBeginningOfSentenceCase(
                                                                          message
                                                                              .senderFirstName)!,
                                                                      minFontSize:
                                                                          10,
                                                                      maxFontSize:
                                                                          12,
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  AutoSizeText(
                                                                    toBeginningOfSentenceCase(
                                                                        message
                                                                            .message)!,
                                                                    minFontSize:
                                                                        10,
                                                                    maxFontSize:
                                                                        12,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
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
                                            SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(16.0),
                                                    child: Row(
                                                      children: [
                                                        // Champ de saisie de texte avec icône à droite
                                                        Expanded(
                                                          child: TextFormField(
                                                            controller:
                                                                _textController,
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                              ),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          15,
                                                                          5,
                                                                          10,
                                                                          5),
                                                              hintText:
                                                                  "Message",
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                          ),
                                                        ),
                                                        // Icône et bouton d'envoi
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.send),
                                                          onPressed: () async {
                                                            int count =
                                                                await GroupsService()
                                                                    .getUserCountInGroup(
                                                              token.toString(),
                                                              message.groupId
                                                                  .toString(),
                                                            );

                                                            setState(() {
                                                              userCount = count;
                                                            });

                                                            String otherUser =
                                                                message.senderId !=
                                                                        userId
                                                                    ? message
                                                                        .senderId
                                                                    : message
                                                                        .responderId;

                                                            if (showPremium) {
                                                              userMessagesCount =
                                                                  await MessagesService()
                                                                      .getAllMessagesByUserId(
                                                                          token
                                                                              .toString(),
                                                                          userId
                                                                              .toString());
                                                              if (userCount ==
                                                                  2) {
                                                                if (discussion
                                                                        ?.messages
                                                                        .length ==
                                                                    0) {
                                                                  await send(
                                                                      null,
                                                                      _textController
                                                                          .text,
                                                                      otherUser);
                                                                  userMessagesCount =
                                                                      await MessagesService().getAllMessagesByUserId(
                                                                          token
                                                                              .toString(),
                                                                          userId
                                                                              .toString());
                                                                } else {
                                                                  await send(
                                                                      message
                                                                          .groupId,
                                                                      _textController
                                                                          .text,
                                                                      otherUser);
                                                                  userMessagesCount =
                                                                      await MessagesService().getAllMessagesByUserId(
                                                                          token
                                                                              .toString(),
                                                                          userId
                                                                              .toString());
                                                                }
                                                              } else {
                                                                if (discussion
                                                                        ?.messages
                                                                        .length ==
                                                                    0) {
                                                                  await send(
                                                                      null,
                                                                      _textController
                                                                          .text,
                                                                      otherUser);
                                                                  userMessagesCount =
                                                                      await MessagesService().getAllMessagesByUserId(
                                                                          token
                                                                              .toString(),
                                                                          userId
                                                                              .toString());
                                                                } else {
                                                                  await send(
                                                                      message
                                                                          .groupId,
                                                                      _textController
                                                                          .text,
                                                                      otherUser);
                                                                  userMessagesCount =
                                                                      await MessagesService().getAllMessagesByUserId(
                                                                          token
                                                                              .toString(),
                                                                          userId
                                                                              .toString());
                                                                }
                                                              }
                                                            } else if (userMessagesCount <
                                                                    5 &&
                                                                !showPremium) {
                                                              userMessagesCount =
                                                                  await MessagesService()
                                                                      .getAllMessagesByUserId(
                                                                          token
                                                                              .toString(),
                                                                          userId
                                                                              .toString());
                                                              if (userCount ==
                                                                  2) {
                                                                if (discussion
                                                                        ?.messages
                                                                        .length ==
                                                                    0) {
                                                                  await send(
                                                                      null,
                                                                      _textController
                                                                          .text,
                                                                      otherUser);
                                                                  userMessagesCount =
                                                                      await MessagesService().getAllMessagesByUserId(
                                                                          token
                                                                              .toString(),
                                                                          userId
                                                                              .toString());
                                                                } else {
                                                                  await send(
                                                                      message
                                                                          .groupId,
                                                                      _textController
                                                                          .text,
                                                                      otherUser);
                                                                  userMessagesCount =
                                                                      await MessagesService().getAllMessagesByUserId(
                                                                          token
                                                                              .toString(),
                                                                          userId
                                                                              .toString());
                                                                }
                                                              } else {
                                                                if (discussion
                                                                        ?.messages
                                                                        .length ==
                                                                    0) {
                                                                  await send(
                                                                      null,
                                                                      _textController
                                                                          .text,
                                                                      otherUser);
                                                                  userMessagesCount =
                                                                      await MessagesService().getAllMessagesByUserId(
                                                                          token
                                                                              .toString(),
                                                                          userId
                                                                              .toString());
                                                                } else {
                                                                  await send(
                                                                      message
                                                                          .groupId,
                                                                      _textController
                                                                          .text,
                                                                      otherUser);
                                                                  userMessagesCount =
                                                                      await MessagesService().getAllMessagesByUserId(
                                                                          token
                                                                              .toString(),
                                                                          userId
                                                                              .toString());
                                                                }
                                                              }
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {
                                                                showPremium =
                                                                    true;
                                                              });
                                                              userMessagesCount =
                                                                  await MessagesService()
                                                                      .getAllMessagesByUserId(
                                                                          token
                                                                              .toString(),
                                                                          userId
                                                                              .toString());
                                                              _textController
                                                                  .clear();
                                                            }

                                                            var newDisc =
                                                                await getDiscussionsForMessageWith(
                                                              discussionMessages!
                                                                  .groups[index]
                                                                  .lastMessage
                                                                  .id
                                                                  .toString(),
                                                            );

                                                            // Update the local state with the new discussions data
                                                            setState(() {
                                                              discussion =
                                                                  newDisc;
                                                            });

                                                            _textController
                                                                .clear();
                                                            _handleSubmitted(
                                                                _textController
                                                                    .text);

                                                            // Faites défiler vers le bas après l'envoi du message
                                                            _scrollController
                                                                .animateTo(
                                                              _scrollController
                                                                  .position
                                                                  .maxScrollExtent,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300),
                                                              curve: Curves
                                                                  .easeOut,
                                                            );
                                                          },
                                                        ), //build
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              context: currentContext!,
                            );

                            if (!discussionMessages!.groups[index].usersRead!
                                .contains(userId)) {
                              await MessageService()
                                  .setMessageRead(token!, message.id, userId!);
                            }
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
                                            return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 5, sigmaY: 5)),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Text(
                                              '',
                                              textAlign: TextAlign.center,
                                            );
                                          } else if (!snapshot.hasData) {
                                            return const Text('');
                                          }

                                          var image = snapshot.data!;

                                          var avatar = image
                                                  .userImages.isNotEmpty
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      image
                                                          .userImages[0].image),
                                                  maxRadius: 25,
                                                )
                                              : CircleAvatar(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 220, 234, 250),
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
                                          SizedBox(
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
                                          !discussionMessages!
                                                      .groups[index].usersRead!
                                                      .contains(userId) &&
                                                  discussionMessages!
                                                          .groups[index]
                                                          .lastMessage
                                                          .senderId !=
                                                      userId
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AutoSizeText(
                        "Filtres",
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
                          "Réinitialiser",
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: TextStyle(color: Color(0xFF0081CF)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Row(
                    children: [
                      AutoSizeText(
                        "Voir que les conversations",
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontFamily: "Poppins",
                        ),
                        minFontSize: 16,
                        maxFontSize: 18,
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
                          offset: const Offset(0, 3),
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
                                borderRadius: const BorderRadius.only(
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
                                borderRadius: const BorderRadius.only(
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
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                readButtonColor = Colors.blue;
                                readTextColor = Colors.white;
                                unreadButtonColor = Colors.white;
                                unreadTextColor = Colors.black;
                                filterSeulGroup = "lu";
                              });
                              await getDiscussionsByFilter();
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: readButtonColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Lu',
                                  style: TextStyle(
                                    color: readTextColor,
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
                                unreadButtonColor = Colors.blue;
                                unreadTextColor = Colors.white;
                                readButtonColor = Colors.white;
                                readTextColor = Colors.black;
                                filterSeulGroup = "nonLu";
                              });
                              await getDiscussionsByFilter();
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: unreadButtonColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Non Lu',
                                  style: TextStyle(
                                    color: unreadTextColor,
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
                  const SizedBox(height: 20),
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
                          DropdownButtonFormField<String>(
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
                              items: locationList.map<DropdownMenuItem<String>>(
                                  (dynamic value) {
                                return DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: Text(value.toString()),
                                );
                              }).toList()),
                        ]),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () async {
                            if (selectedLocation != null &&
                                selectedLocation!.isNotEmpty) {
                              setState(() => filterSeulGroup = "location");
                            }

                            await getDiscussionsByFilter();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0081CF)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                            child: AutoSizeText(
                                "Appliquer le filtre localisation",
                                minFontSize: 15,
                                maxFontSize: 17,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 30),
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
