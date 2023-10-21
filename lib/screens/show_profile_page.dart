import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/photoList.dart';
import 'package:viami/models-api/user.dart';
import 'package:viami/services/user.service.dart';

class ShowProfilePage extends StatefulWidget {
  const ShowProfilePage({Key? key}) : super(key: key);

  @override
  State<ShowProfilePage> createState() => _ShowProfilePageState();
}

class _ShowProfilePageState extends State<ShowProfilePage> {
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
    return Scaffold(
        body: FutureBuilder<User>(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var user = snapshot.data!;
                return const Align(
                  alignment: Alignment.topLeft,
                  child: AutoSizeText(
                    "Média",
                    minFontSize: 10,
                    maxFontSize: 12,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }

              return const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            }));
  }
}
