import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/screens/edit_profile_page.dart';
import 'package:viami/screens/show_profile_page.dart';
import 'package:viami/services/user/user.service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  @override
  Widget build(BuildContext context) {
    String currentAction = "Edit";
    Color currentColor = Colors.blue;

    return Scaffold(
        body: SingleChildScrollView(
            child: FutureBuilder<User>(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var user = snapshot.data!;
                    return SingleChildScrollView(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
                            child: Column(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                            size: 20,
                                          )),
                                      const Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 40, 0),
                                              child: AutoSizeText(
                                                "Mon profil",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                minFontSize: 18,
                                                maxFontSize: 20,
                                                textAlign: TextAlign.center,
                                              )))
                                    ]),
                                const SizedBox(height: 10),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DecoratedBox(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          child: TextButton(
                                              onPressed: () {},
                                              style: const ButtonStyle(
                                                  padding:
                                                      MaterialStatePropertyAll(
                                                          EdgeInsets.fromLTRB(
                                                              30, 0, 30, 0))),
                                              child: AutoSizeText(
                                                "Modifier",
                                                minFontSize: 9,
                                                maxFontSize: 12,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        currentAction == "Edit"
                                                            ? currentColor
                                                            : Colors.black),
                                              ))),
                                      TextButton(
                                          onPressed: () {},
                                          child: AutoSizeText(
                                            "Aperçu",
                                            minFontSize: 9,
                                            maxFontSize: 12,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: currentAction != "Edit"
                                                    ? currentColor
                                                    : Colors.black),
                                          ),
                                          style: const ButtonStyle(
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.fromLTRB(
                                                      30, 0, 30, 0))))
                                    ]),
                                const SizedBox(height: 10),
                                currentAction == "Edit"
                                    ? EditProfilePage(user: user)
                                    : const ShowProfilePage()
                              ],
                            )));
                  }

                  return const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
                })));
  }
}
