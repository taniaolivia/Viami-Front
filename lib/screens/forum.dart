import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:viami/models-api/forum/forumCities.dart';
import 'package:viami/models-api/travel/travels.dart';
import 'package:viami/services/forum/forumCities.service.dart';
import 'package:viami/services/travel/travels.service.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final storage = const FlutterSecureStorage();
  String? token;

  Future<ForumCities> getAllForumCities() {
    Future<ForumCities> getListForumCities() async {
      token = await storage.read(key: "token");

      return ForumCitiesService().getAllForumCities(token.toString());
    }

    return getListForumCities();
  }

  @override
  void initState() {
    getAllForumCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ForumCities>(
        future: getAllForumCities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height));
          }

          if (snapshot.hasError) {
            return Text(
              '${snapshot.error}',
              textAlign: TextAlign.center,
            );
          }

          if (!snapshot.hasData) {
            return Text('');
          }

          var cities = snapshot.data!;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      cities.forumCities.length,
                      (index) {
                        return Column(children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                '${dotenv.env['CDN_URL']}/assets/${cities.forumCities[index].image['image']}'),
                            minRadius: 25,
                            maxRadius: 30,
                          ),
                          const SizedBox(height: 10, width: 80),
                          AutoSizeText(
                            cities.forumCities[index].city,
                            minFontSize: 11,
                            maxFontSize: 13,
                          )
                        ]);
                      },
                    ),
                  )),
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.swap_vert))),
              const SizedBox(height: 30),
              Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    elevation: 2,
                    backgroundColor: const Color(0xFF0081CF),
                    child: const Icon(Icons.add, color: Colors.white),
                    onPressed: () async {},
                  )),
              const SizedBox(height: 10),
            ],
          );
        });
  }
}
