import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/services/userImage/usersImages.service.dart';

class MenuWidget extends StatelessWidget {
  String? token = "";
  String? userId = "";
  final storage = const FlutterSecureStorage();

  Future<UsersImages> getUserImages() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return UsersImagesService()
        .getUserImagesById(userId.toString(), token.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UsersImages>(
        future: getUserImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            );
          } else if (snapshot.hasError) {
            return const Text(
              '',
              textAlign: TextAlign.center,
            );
          } else if (!snapshot.hasData) {
            return const Text('');
          }

          var images = snapshot.data!;

          return GestureDetector(
              onTap: () => ZoomDrawer.of(context)!.toggle(),
              child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0081CF),
                      width: 2.0,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width <= 320 ? 80 : 100,
                  child: images.userImages.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(images.userImages[0].image),
                          radius: 40.0,
                        )
                      : const CircleAvatar(
                          radius: 40.0,
                          child: Icon(
                            Icons.person,
                            size: 30,
                          ))));
        });
  }
}
