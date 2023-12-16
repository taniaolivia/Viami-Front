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

class ShowProfilePage extends StatefulWidget {
  final String userId;
  final bool showButton;
  const ShowProfilePage(
      {Key? key, required this.userId, required this.showButton})
      : super(key: key);

  @override
  State<ShowProfilePage> createState() => _ShowProfilePageState();
}

class _ShowProfilePageState extends State<ShowProfilePage> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";

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

  @override
  void initState() {
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
                  return Text("");
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return Text('');
                }
                var user = snapshot.data![0] as User;
                var images = snapshot.data![1] as UsersImages;

                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2.3,
                          padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                              color: const Color.fromRGBO(0, 0, 0, 0.1),
                              image: images.userImages.length != 0
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          images.userImages[0].image),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      colorFilter:
                                          const ColorFilter.linearToSrgbGamma(),
                                      image: NetworkImage(
                                          "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center)),
                          child: Column(children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    width: 50,
                                    height: 50,
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 2, 0, 0),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, "/home");
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          color: Color.fromRGBO(0, 0, 0, 0.4),
                                          size: 20,
                                        )))),
                            widget.showButton == false
                                ? Container(
                                    height: MediaQuery.of(context).size.height /
                                        3.5,
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            width: 70,
                                            height: 70,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 2, 0, 0),
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40))),
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, "/messages");
                                                },
                                                icon: const Icon(
                                                  Icons.message_rounded,
                                                  color: Color(0xFF0081CF),
                                                  size: 30,
                                                )))))
                                : Container(),
                          ])),
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
                              images.userImages.length == 0
                                  ? Container(
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
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                          images.userImages.length, (index) {
                                        return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            height: 150,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: const Color.fromRGBO(
                                                    0, 0, 0, 0.1),
                                                image: images.userImages
                                                            .length !=
                                                        0
                                                    ? DecorationImage(
                                                        image: NetworkImage(
                                                            images
                                                                .userImages[
                                                                    index]
                                                                .image),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : DecorationImage(
                                                        colorFilter:
                                                            const ColorFilter
                                                                .linearToSrgbGamma(),
                                                        image: NetworkImage(
                                                            "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                                        fit: BoxFit.contain,
                                                        alignment:
                                                            Alignment.center)));
                                      })),
                              const SizedBox(height: 120),
                            ]),
                          )),
                    ])));
              })
        ])),
        floatingActionButton: widget.showButton == true
            ? Container(
                height: 40.0,
                width: 140.0,
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
}
