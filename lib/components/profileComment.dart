import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userComment/usersComments.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userComment/usersComments.service.dart';

class ProfileComment extends StatefulWidget {
  final String userId;
  const ProfileComment({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileComment> createState() => _ProfileCommentState();
}

class _ProfileCommentState extends State<ProfileComment> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String commenterId = "";

  @override
  Widget build(BuildContext context) {
    Future<UsersComments> getAllComments() async {
      token = await storage.read(key: "token");

      final comments = UsersCommentsService()
          .getUserCommentsById(widget.userId, token.toString());

      return comments;
    }

    Future<User> getUser() {
      Future<User> getConnectedUser() async {
        token = await storage.read(key: "token");

        return UserService().getUserById(commenterId, token.toString());
      }

      return getConnectedUser();
    }

    getAllComments();

    @override
    void initState() {
      super.initState();
    }

    return Column(children: [
      const SizedBox(height: 20),
      const Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            "Avis",
            minFontSize: 11,
            maxFontSize: 13,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          )),
      const SizedBox(height: 10),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder<UsersComments>(
              future: getAllComments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height));
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return const Text('');
                }

                var comment = snapshot.data!;

                commenterId = comment.userComments.isNotEmpty
                    ? comment.userComments[0].commenterId
                    : '';

                return comment.userComments.length != 0
                    ? Row(
                        children:
                            List.generate(comment.userComments.length, (index) {
                        return Container(
                            width: MediaQuery.of(context).size.width / 1.3,
                            constraints: const BoxConstraints(
                                minHeight: 150, maxHeight: double.infinity),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Column(
                              children: [
                                FutureBuilder<User>(
                                    future: getUser(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text("");
                                      }

                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }

                                      if (!snapshot.hasData) {
                                        return Text('');
                                      }

                                      var commenter = snapshot.data!;
                                      return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            AutoSizeText(
                                              "${commenter.firstName} ${commenter.lastName}",
                                              minFontSize: 11,
                                              maxFontSize: 13,
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            CircleAvatar(
                                                backgroundImage: commenter
                                                            .profileImage !=
                                                        null
                                                    ? AssetImage(
                                                        commenter.profileImage!)
                                                    : null,
                                                backgroundColor: commenter
                                                            .profileImage ==
                                                        null
                                                    ? const Color(0xFF0081CF)
                                                    : null,
                                                child: commenter.profileImage ==
                                                        null
                                                    ? const Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                      )
                                                    : null)
                                          ]);
                                    }),
                                const SizedBox(height: 10),
                                AutoSizeText(
                                    comment.userComments[index].comment,
                                    minFontSize: 11,
                                    maxFontSize: 13,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    )),
                              ],
                            ));
                      }))
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        child: const AutoSizeText(
                          "Aucun avis",
                          minFontSize: 11,
                          maxFontSize: 13,
                          textAlign: TextAlign.left,
                        ));
              })),
      const SizedBox(height: 30),
    ]);
  }
}
