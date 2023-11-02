import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/dialogMessage.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';

import '../widgets/menu_widget.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});
  final storage = const FlutterSecureStorage();
  String? token = "";
  String? userId = "";
  String? userProfile;
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
            ));
      });
    }
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: MenuWidget(),
        elevation: 0,
        backgroundColor: const Color(0xFFFAFAFA),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                '${dotenv.env['CDN_URL']}assets/location.png',
                width: 20.0,
                height: 20.0,
                color: const Color(0xFF0081CF),
              ),
              const SizedBox(width: 8.0),
              const Text(
                "Paris",
                style: TextStyle(color: Color(0xFF000000)),
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF6D7D95)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFFFFFF),
                  width: 2.0,
                ),
              ),
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage('${dotenv.env['CDN_URL']}/assets/profil.png'),
                radius: 16,
              ),
            ),
          )
        ],
      ),
      body: const Text(
        "NotificationsPage",
        style: TextStyle(color: Colors.black12),
      ),
    );
  }
}
