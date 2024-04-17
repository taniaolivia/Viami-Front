import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/interestComponent.dart';
import 'package:viami/components/languageComponent.dart';
import 'package:viami/components/profileComment.dart';
import 'package:viami/components/profileData.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';

import '../services/userComment/userComment.service.dart';

class ShowProfilePage extends StatefulWidget {
  final String userId;
  final bool showButton;
  final bool showComment;
  const ShowProfilePage(
      {Key? key,
      required this.userId,
      required this.showButton,
      required this.showComment})
      : super(key: key);

  @override
  State<ShowProfilePage> createState() => _ShowProfilePageState();
}

class _ShowProfilePageState extends State<ShowProfilePage> {
  TextEditingController commentController = TextEditingController();
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  bool? hasUserLeftComment;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UserService().getUserById(widget.userId, token.toString());
    }

    return getConnectedUser();
  }

  Future<UsersImages> getUserImages() async {
    token = await storage.read(key: "token");

    final images = await UsersImagesService()
        .getUserImagesById(widget.userId, token.toString());

    return images;
  }

  Future<bool> getHasComment() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    final hasUserLeftComment = await UserCommentService()
        .hasUserLeftComment(userId!, widget.userId, token.toString());

    return hasUserLeftComment;
  }

  @override
  void initState() {
    getUser();
    getUserImages();
    getHasComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          FutureBuilder<List<Object>>(
              future: Future.wait([getUser(), getUserImages()]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.2,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF0081CF)),
                    ),
                  );
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
                var user = snapshot.data![0] as User;
                var images = snapshot.data![1] as UsersImages;

                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: images.userImages.isNotEmpty
                                              ? NetworkImage(
                                                  images.userImages[0].image)
                                              : NetworkImage(
                                                  "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Center(
                              child: Hero(
                                  tag: images.userImages.isNotEmpty
                                      ? images.userImages[0].image
                                      : "${dotenv.env['CDN_URL']}/assets/noprofile.png",
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2.3,
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 40, 0, 0),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(30),
                                              bottomRight: Radius.circular(30)),
                                          color: const Color.fromRGBO(
                                              0, 0, 0, 0.1),
                                          image: images.userImages.isNotEmpty
                                              ? DecorationImage(
                                                  image: NetworkImage(images
                                                      .userImages[0].image),
                                                  fit: BoxFit.cover,
                                                )
                                              : DecorationImage(
                                                  colorFilter: const ColorFilter
                                                      .linearToSrgbGamma(),
                                                  image: NetworkImage(
                                                      "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                                  fit: BoxFit.contain,
                                                  alignment: Alignment.center)),
                                      child: Column(children: [
                                        Padding(
                                            padding: MediaQuery.of(context).size.width <= 450
                                                ? const EdgeInsets.fromLTRB(
                                                    5, 15, 0, 0)
                                                : const EdgeInsets.fromLTRB(
                                                    5, 35, 0, 0),
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                    width: MediaQuery.of(context)
                                                                .size
                                                                .width <=
                                                            450
                                                        ? 40
                                                        : 50,
                                                    height: MediaQuery.of(context)
                                                                .size
                                                                .width <=
                                                            450
                                                        ? 40
                                                        : 50,
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            5, 0, 0, 0),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(10))),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                              context, "/home");
                                                        },
                                                        icon: const Icon(
                                                          Icons.arrow_back_ios,
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 0.4),
                                                          size: 20,
                                                        ))))),
                                        widget.showButton == false
                                            ? SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3.5,
                                                child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                        width: 70,
                                                        height: 70,
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 2, 0, 0),
                                                        decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            40))),
                                                        child: IconButton(
                                                            onPressed: () {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  "/messages");
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .message_rounded,
                                                              color: Color(
                                                                  0xFF0081CF),
                                                              size: 30,
                                                            )))))
                                            : Container(),
                                      ]))))),
                      Container(
                          padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                          alignment: Alignment.bottomCenter,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: SingleChildScrollView(
                            child: Column(children: [
                              ProfileData(user: user),
                              InterestComponent(
                                  page: "show", userId: widget.userId),
                              LanguageComponent(
                                  page: "show", userId: widget.userId),
                              ProfileComment(userId: widget.userId),
                              const Align(
                                  alignment: Alignment.topLeft,
                                  child: AutoSizeText(
                                    "Galerie de photos",
                                    minFontSize: 11,
                                    maxFontSize: 13,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  )),
                              const SizedBox(height: 10),
                              images.userImages.isEmpty
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 20,
                                      child: const AutoSizeText(
                                        "Aucune photo",
                                        minFontSize: 11,
                                        maxFontSize: 13,
                                        textAlign: TextAlign.left,
                                      ))
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                          images.userImages.length, (index) {
                                        return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: images.userImages
                                                              .isNotEmpty
                                                          ? Image.network(images
                                                              .userImages[index]
                                                              .image)
                                                          : Image.network(
                                                              "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Hero(
                                                tag: images.userImages.isNotEmpty
                                                    ? images
                                                        .userImages[index].image
                                                    : "${dotenv.env['CDN_URL']}/assets/noprofile.png",
                                                child: Container(
                                                    margin: const EdgeInsets.only(
                                                        right: 10),
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4,
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        color:
                                                            const Color.fromRGBO(
                                                                0, 0, 0, 0.1),
                                                        image: images.userImages
                                                                    .length !=
                                                                0
                                                            ? DecorationImage(
                                                                image: NetworkImage(images
                                                                    .userImages[
                                                                        index]
                                                                    .image),
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : DecorationImage(
                                                                colorFilter:
                                                                    const ColorFilter.linearToSrgbGamma(),
                                                                image: NetworkImage("${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                                                fit: BoxFit.contain,
                                                                alignment: Alignment.center)))));
                                      })),
                              const SizedBox(height: 100),
                              Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        FutureBuilder<bool>(
                                          future: getHasComment(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Text("");
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                '',
                                                textAlign: TextAlign.center,
                                              );
                                            } else {
                                              bool hasLeftComment =
                                                  snapshot.data ?? false;

                                              if (!hasLeftComment &&
                                                  widget.showComment) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: TextField(
                                                        controller:
                                                            commentController,
                                                        maxLines: 3,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Laissez un commentaire...',
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        String comment =
                                                            commentController
                                                                .text;
                                                        await UserCommentService()
                                                            .addComment(
                                                                userId!,
                                                                widget.userId,
                                                                comment,
                                                                token
                                                                    .toString());

                                                        _showCommentSentDialog();

                                                        commentController
                                                            .clear();
                                                      },
                                                      child:
                                                          const Text('Envoyer'),
                                                    ),
                                                  ],
                                                );
                                              } else if (hasLeftComment &&
                                                  widget.showComment) {
                                                return AutoSizeText(
                                                  'Vous avez déjà laissé un commentaire pour ce voyageur...',
                                                  minFontSize: 20,
                                                  maxFontSize: 22,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                );
                                              } else {
                                                return Container(
                                                  child: Text(""),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                      ]))
                            ]),
                          )),
                    ])));
              }),
        ])),
        floatingActionButton: widget.showButton == true
            ? Container(
                height: 40.0,
                width: 140.0,
                margin: const EdgeInsets.only(bottom: 70),
                child: FloatingActionButton(
                    backgroundColor: const Color(0xFF0081CF),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    onPressed: () {
                      Navigator.pushNamed(context, "/profile");
                    },
                    child: const AutoSizeText(
                      "Modifier",
                      minFontSize: 11,
                      maxFontSize: 13,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                    )))
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Future<void> _showCommentSentDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Commentaire envoyé'),
          content: Text('Votre commentaire a été envoyé avec succès.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ShowProfilePage(
                        userId: widget.userId,
                        showButton: widget.showButton,
                        showComment: widget.showComment,
                      ),
                    ));
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
