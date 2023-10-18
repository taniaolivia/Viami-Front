import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/user.dart';
import 'package:viami/services/user.service.dart';

class ProfilePage extends StatelessWidget {
  final storage = FlutterSecureStorage();

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
    return Scaffold(
        body: FutureBuilder<User>(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var user = snapshot.data!;
                return Column(
                  children: <Widget>[
                    const Text("ProfilePage",
                        style: TextStyle(color: Colors.black12)),
                    Text("Name : ${user.firstName}")
                  ],
                );
              } else {}

              return const CircularProgressIndicator();
            }));
  }
}
