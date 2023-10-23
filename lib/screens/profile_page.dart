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
  String currentAction = "edit";
  Color currentColor = Colors.blue;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  void initState() {
    currentAction = currentAction;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const AutoSizeText(
            "Mon profil",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins"),
            minFontSize: 18,
            maxFontSize: 20,
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              )),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<User>(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var user = snapshot.data!;
                    return SingleChildScrollView(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                            child: Column(
                              children: <Widget>[
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
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  currentAction = "edit";
                                                });
                                              },
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          25, 10, 25, 10),
                                                  child: AutoSizeText(
                                                    "Modifier",
                                                    minFontSize: 11,
                                                    maxFontSize: 13,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: currentAction ==
                                                                "edit"
                                                            ? currentColor
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )))),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            currentAction = "show";
                                          });
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                25, 10, 25, 10),
                                            child: AutoSizeText(
                                              "Aperçu",
                                              minFontSize: 11,
                                              maxFontSize: 13,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: currentAction != "edit"
                                                      ? currentColor
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      )
                                    ]),
                                const SizedBox(height: 10),
                                currentAction == "edit"
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
