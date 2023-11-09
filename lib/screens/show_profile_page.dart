import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
  const ShowProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ShowProfilePage> createState() => _ShowProfilePageState();
}

class _ShowProfilePageState extends State<ShowProfilePage> {
  final storage = const FlutterSecureStorage();

  String? token = "";

  @override
  Widget build(BuildContext context) {
    Future<User> getUser() {
      Future<User> getConnectedUser() async {
        token = await storage.read(key: "token");

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

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          FutureBuilder<List<Object>>(
              future: Future.wait([getUser(), getUserImages()]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
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
                          padding: const EdgeInsets.fromLTRB(15, 40, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                              image: DecorationImage(
                                  image: FileImage(
                                      File(images.userImages[0].image)),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center)),
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/home");
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                                size: 25,
                              )),
                        ),
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
                                ProfileComment(user: user),
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
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                        images.userImages.length, (index) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            image: DecorationImage(
                                                image: FileImage(File(images
                                                    .userImages[index].image)),
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center)),
                                      );
                                    })),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 10, 30, 10),
                                        backgroundColor: Colors.blue,
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)))),
                                    onPressed: () async {
                                      Navigator.pushNamed(context, "/profile");
                                    },
                                    child: const AutoSizeText(
                                      "Modifier",
                                      minFontSize: 11,
                                      maxFontSize: 13,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins"),
                                    )),
                                const SizedBox(height: 50),
                              ]),
                            )),
                      ])));
                }

                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.3,
                    padding: const EdgeInsets.fromLTRB(15, 40, 0, 0),
                    child: const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()));
              })
        ])));
  }
}
