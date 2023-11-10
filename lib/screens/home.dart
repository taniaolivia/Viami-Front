import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/dialogMessage.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/screens/popularTheme.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
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
  void initState() {
    super.initState();
    getUser();
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(children: [
        FutureBuilder<User>(
            future: getUser(),
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

              var user = snapshot.data!;

              return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        "Salut ${toBeginningOfSentenceCase(user.firstName)},",
                        minFontSize: 15,
                        maxFontSize: 18,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Color(0xFF39414B),
                            fontWeight: FontWeight.w300),
                      )));
            }),
        const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: AutoSizeText(
              "Trouve ton / ta partenaire pour voyager ?",
              minFontSize: 22,
              maxFontSize: 25,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xFF0A2753), fontWeight: FontWeight.bold),
            )),
        const PopularThemePage()
      ])),
    );
  }
}
