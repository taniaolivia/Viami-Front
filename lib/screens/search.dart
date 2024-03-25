import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/generalTemplate.dart';
import 'package:viami/models-api/travel/travels.dart';
import 'package:viami/screens/forum.dart';
import 'package:viami/screens/searchTravel.dart';
import 'package:viami/services/travel/travels.service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String? token;
  String? selectedLocation;
  List locationList = [""];
  String fillDestination = "";
  String page = "rejoindre";

  Future<Travels> getListTravels() {
    Future<Travels> getAllTravels() async {
      token = await storage.read(key: "token");

      return TravelsService().getAllTravels(token.toString());
    }

    return getAllTravels();
  }

  @override
  void initState() {
    fillDestination = "";
    getListTravels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GeneralTemplate(
          image: "${dotenv.env['CDN_URL']}/assets/travels.jpg",
          imageHeight: MediaQuery.of(context).size.width <= 320 ? 3 : 3,
          content:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            UnconstrainedBox(
                child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 15, 40, 15),
                              backgroundColor: const Color(0xFF0081CF),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          child: const AutoSizeText(
                            "Rejoindre",
                            maxLines: 1,
                            minFontSize: 11,
                            maxFontSize: 13,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontFamily: "Poppins", color: Colors.white),
                          ),
                          onPressed: () async {
                            setState(() {
                              page = "rejoindre";
                            });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 15, 40, 15),
                              backgroundColor: Colors.white,
                              shadowColor: Colors.white,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          child: const AutoSizeText(
                            "Forum",
                            maxLines: 1,
                            minFontSize: 11,
                            maxFontSize: 13,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontFamily: "Poppins", color: Colors.black),
                          ),
                          onPressed: () async {
                            setState(() {
                              page = "forum";
                            });
                          },
                        ),
                      ],
                    ))),
            const SizedBox(height: 40.0),
            page == "rejoindre" ? const SearchTravelPage() : const ForumPage()
          ]),
          contentHeight: MediaQuery.of(context).size.width <= 320 ? 4.2 : 5,
          containerHeight: MediaQuery.of(context).size.width <= 320 ? 1.7 : 1.3,
          title: "Recherche",
          redirect: "/home",
        ));
  }
}
