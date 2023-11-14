import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/dialogMessage.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/screens/profileEdit.dart';
import 'package:viami/screens/showProfile.dart';
import 'package:viami/services/user/auth.service.dart';
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
  bool? tokenExpired;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");
      bool isTokenExpired = AuthService().isTokenExpired(token!);

      tokenExpired = isTokenExpired;

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  @override
  Widget build(BuildContext context) {
    if (tokenExpired == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0081CF),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              )),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<User>(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("");
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return const Text('');
                  }

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
                                            right:
                                                BorderSide(color: Colors.grey),
                                          ),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                25, 10, 25, 10),
                                            child: AutoSizeText(
                                              "Modifier",
                                              minFontSize: 11,
                                              maxFontSize: 13,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: currentColor,
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            FadePageRoute(
                                                page: ShowProfilePage(
                                                    userId: userId!)));
                                      },
                                      child: const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              25, 10, 25, 10),
                                          child: AutoSizeText(
                                            "Aperçu",
                                            minFontSize: 11,
                                            maxFontSize: 13,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  ]),
                              const SizedBox(height: 10),
                              EditProfilePage(user: user)
                            ],
                          )));
                })));
  }
}
