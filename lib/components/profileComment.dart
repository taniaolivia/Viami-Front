import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userComment/usersComments.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userComment/usersComments.service.dart';

class ProfileComment extends StatefulWidget {
  final User user;
  const ProfileComment({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileComment> createState() => _ProfileCommentState();
}

class _ProfileCommentState extends State<ProfileComment> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String commenterId = "";

  @override
  Widget build(BuildContext context) {
    Future<UsersComments> getUserComments() {
      Future<UsersComments> getAllComments() async {
        token = await storage.read(key: "token");

        return UsersCommentsService()
            .getUserCommentsById(widget.user.id!, token.toString());
      }

      return getAllComments();
    }

    Future<User> getUser() {
      Future<User> getConnectedUser() async {
        token = await storage.read(key: "token");

        return UserService().getUserById(commenterId, token.toString());
      }

      return getConnectedUser();
    }

    return FutureBuilder<UsersComments>(
        future: getUserComments(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var comment = snapshot.data!;

            commenterId = comment.userComments[0].commenterId;

            return Column(children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: AutoSizeText(
                    "Avis",
                    minFontSize: 11,
                    maxFontSize: 13,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  )),
              const SizedBox(height: 10),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children:
                          List.generate(comment.userComments.length, (index) {
                    return Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        constraints: const BoxConstraints(
                            minHeight: 100, maxHeight: double.infinity),
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          children: [
                            FutureBuilder<User>(
                                future: getUser(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
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
                                              child:
                                                  commenter.profileImage == null
                                                      ? const Icon(Icons.person)
                                                      : null)
                                        ]);
                                  }
                                  return const Align(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator());
                                }),
                            const SizedBox(height: 10),
                            AutoSizeText(comment.userComments[index].comment,
                                minFontSize: 11,
                                maxFontSize: 13,
                                style: const TextStyle(
                                  color: Colors.black,
                                )),
                          ],
                        ));
                  }))),
              const SizedBox(height: 30),
            ]);
          }
          return const Align(
              alignment: Alignment.center, child: CircularProgressIndicator());
        });
  }
}
