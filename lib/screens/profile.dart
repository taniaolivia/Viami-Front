import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/screens/profileEdit.dart';
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

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0081CF),
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              )),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: FutureBuilder<User>(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("");
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

                  var user = snapshot.data!;

                  return SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                          child: Column(
                            children: <Widget>[EditProfilePage(user: user)],
                          )));
                })));
  }
}
