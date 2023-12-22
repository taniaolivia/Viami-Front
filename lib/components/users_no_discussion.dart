import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/models-api/requestMessage/requests_messages.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/models-api/userStatus/userStatus.dart';
import 'package:viami/services/message/message.service.dart';
import 'package:viami/services/requestMessage/request_message_service.dart';
import 'package:viami/services/requestMessage/requests_messages_service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';
import 'package:viami/services/userStatus/userStatus.service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UsersNoDiscussionPage extends StatefulWidget {
  const UsersNoDiscussionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UsersNoDiscussionPage> createState() => _UsersNoDiscussionPageState();
}

class _UsersNoDiscussionPageState extends State<UsersNoDiscussionPage> {
  final storage = const FlutterSecureStorage();
  String? token;
  String userImages = "";
  String? userId = "";
  bool? tokenExpired;
  List? users;
  ScrollController _scrollController = ScrollController();
  late IO.Socket socket;

  TextEditingController searchController = TextEditingController();
  TextEditingController _textReqController = TextEditingController();
  bool _isKeyboardVisible = false;

  Future<void> send(
      int? groupId, String message, String? responderId, int requestId) async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");
    // Envoyez le message à l'aide de l'ID de discussion
    var messageData = {
      'text': message,
      'discussionId': responderId,
    };

    // Envoyez le message au serveur
    socket.emit('chat message', messageData);

    if (mounted) {
      setState(() {});
    }

    _textReqController.clear();

    await RequestMessageService().setChat(token.toString(), requestId);

    return MessageService()
        .sendMessage(token.toString(), groupId, message, userId, responderId);
  }

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

  Future<RequestsMessages> getAllRequestsAcceptedByUser() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return RequestsMessageService()
        .getAllRequestsAcceptedByUser(token.toString(), userId.toString());
  }

  Future<UserStatus> getUserStatusById(String? travelerId) async {
    token = await storage.read(key: "token");

    return await UserStatusService().getUserStatusById(travelerId!, token!);
  }

  void _handleSubmitted(String text) {
    _textReqController.clear();
  }

  @override
  void dispose() {
    // Disconnect from the Socket.IO server when the widget is destroyed
    socket.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getAllRequestsAcceptedByUser();
    // Connect to the Socket.IO server
    socket = IO.io('${dotenv.env['SO_URL']}');
    socket.connect();

    // Listen for 'chat message' events for real-time updates
    socket.on('chat message', (data) {});
  }

  @override
  Widget build(BuildContext context) {
    if (tokenExpired == true) {
      /* WidgetsBinding.instance.addPostFrameCallback((_) {
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

    return FutureBuilder(
        future: getAllRequestsAcceptedByUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0081CF)),
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

          var acceptedRequests = snapshot.data!;

          return Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(
                          acceptedRequests.requestsMessages.length, (index) {
                    return FutureBuilder(
                        future: Future.wait([
                          getUsersImages(acceptedRequests
                                      .requestsMessages[index].requesterId !=
                                  userId
                              ? acceptedRequests
                                  .requestsMessages[index].requesterId
                              : acceptedRequests
                                  .requestsMessages[index].receiverId),
                          getUserStatusById(acceptedRequests
                                      .requestsMessages[index].requesterId !=
                                  userId
                              ? acceptedRequests
                                  .requestsMessages[index].requesterId
                              : acceptedRequests
                                  .requestsMessages[index].receiverId)
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 100));
                          } else if (snapshot.hasError) {
                            return Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                            );
                          } else if (!snapshot.hasData) {
                            return const Text('');
                          }

                          var image = snapshot.data![0] as UsersImages;
                          var status = snapshot.data![1] as UserStatus;
                          String otherUser = acceptedRequests
                                      .requestsMessages[index].requesterId !=
                                  userId
                              ? acceptedRequests
                                  .requestsMessages[index].requesterId
                              : acceptedRequests
                                  .requestsMessages[index].receiverId;

                          return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          backgroundColor: Colors.white,
                                          surfaceTintColor: Colors.white,
                                          scrollable: true,
                                          content: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 205,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(30),
                                                ),
                                              ),
                                              child: Column(children: [
                                                Container(
                                                    width: 70,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    color: Colors.white,
                                                    child: Stack(children: [
                                                      image.userImages.length !=
                                                              0
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
                                                            )
                                                    ])),
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
                                                            acceptedRequests
                                                                        .requestsMessages[
                                                                            index]
                                                                        .requesterId !=
                                                                    userId
                                                                ? toBeginningOfSentenceCase(
                                                                    acceptedRequests
                                                                        .requestsMessages[
                                                                            index]
                                                                        .requesterFirstName)!
                                                                : toBeginningOfSentenceCase(
                                                                    acceptedRequests
                                                                        .requestsMessages[
                                                                            index]
                                                                        .receiverFirstName)!,
                                                            minFontSize: 10,
                                                            maxFontSize: 12,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
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
                                                                  child: Row(
                                                                    children: [
                                                                      status.status ==
                                                                              "online"
                                                                          ? const Icon(
                                                                              Icons.circle,
                                                                              color: Color.fromARGB(255, 0, 207, 62),
                                                                              size: 10,
                                                                            )
                                                                          : const Text(
                                                                              ""),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
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
                                                                            TextOverflow.ellipsis,
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
                                                        const SizedBox(
                                                            height: 5),
                                                      ]),
                                                ),
                                                const SizedBox(height: 25),
                                                Row(
                                                  children: [
                                                    // Champ de saisie de texte avec icône à droite
                                                    Expanded(
                                                      child: TextFormField(
                                                        controller:
                                                            _textReqController,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                          ),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(15,
                                                                      5, 10, 5),
                                                          hintText: "Message",
                                                          hintStyle: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        keyboardType:
                                                            TextInputType.text,
                                                      ),
                                                    ),
                                                    // Icône et bouton d'envoi
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.send),
                                                      onPressed: () async {
                                                        await send(
                                                            null,
                                                            _textReqController
                                                                .text,
                                                            otherUser,
                                                            acceptedRequests
                                                                .requestsMessages[
                                                                    index]
                                                                .id);
                                                        _textReqController
                                                            .clear();
                                                        _handleSubmitted(
                                                            _textReqController
                                                                .text);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ])));
                                    });
                              },
                              child: Container(
                                  height: 100,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Column(children: [
                                    image.userImages.length != 0
                                        ? CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 181, 181, 181),
                                            backgroundImage: AssetImage(
                                                image.userImages[0].image),
                                          )
                                        : const CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Color.fromARGB(
                                                255, 181, 181, 181),
                                            child: Icon(Icons.person,
                                                size: 40, color: Colors.white)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AutoSizeText(
                                      acceptedRequests.requestsMessages[index]
                                                  .requesterId !=
                                              userId
                                          ? toBeginningOfSentenceCase(
                                              acceptedRequests
                                                  .requestsMessages[index]
                                                  .requesterFirstName)!
                                          : toBeginningOfSentenceCase(
                                              acceptedRequests
                                                  .requestsMessages[index]
                                                  .receiverFirstName)!,
                                      minFontSize: 11,
                                      maxFontSize: 12,
                                    )
                                  ])));
                        });
                  }).toList())));
        });
  }
}
