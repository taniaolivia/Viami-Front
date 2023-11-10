import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/generalTemplate.dart';
import 'package:viami/models-api/travel/travels.dart';
import 'package:viami/screens/drawer.dart';
import 'package:viami/screens/travel_page_details.dart';
import 'package:viami/services/travel/travels.service.dart';

class TravelsPage extends StatefulWidget {
  final Travels? travels;
  const TravelsPage({Key? key, this.travels}) : super(key: key);

  @override
  State<TravelsPage> createState() => _TravelsPageState();
}

class _TravelsPageState extends State<TravelsPage> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  List likedList = [];

  @override
  Widget build(BuildContext context) {
    Future<Travels> getListTravels() {
      Future<Travels> getAllTravels() async {
        token = await storage.read(key: "token");

        return TravelsService().getAllTravels(token.toString());
      }

      return getAllTravels();
    }

    return Scaffold(
        backgroundColor: Colors.white,
        drawer: const DrawerPage(),
        body: GeneralTemplate(
            image: "${dotenv.env['CDN_URL']}/assets/travels.jpg",
            imageHeight: MediaQuery.of(context).size.width <= 320 ? 2.5 : 3.5,
            contentHeight: MediaQuery.of(context).size.width <= 320 ? 3.5 : 4.3,
            containerHeight:
                MediaQuery.of(context).size.width <= 320 ? 1.4 : 1.3,
            title: "Liste de voyages",
            content: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 50, 20, MediaQuery.of(context).size.height / 3.5),
              child: FutureBuilder<Travels>(
                  future: getListTravels(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var travel = snapshot.data!;

                      return Column(
                          children: List.generate(
                              widget.travels != null
                                  ? widget.travels!.travels.length
                                  : travel.travels.length, (index) {
                        return Column(children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TravelPageDetails(
                                        travelId: travel.travels[index].id
                                            .toString()),
                                  ),
                                );
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      border: Border.all(
                                        width: 2,
                                        color: const Color(0xFFDADADA),
                                      ),
                                      color: const Color(0xFFEDEEEF),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 10.0,
                                          spreadRadius: 3.0,
                                          offset: Offset(
                                            5.0,
                                            5.0,
                                          ),
                                        )
                                      ]),
                                  child: Column(children: [
                                    Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        height: MediaQuery.of(context).size.width <=
                                                320
                                            ? MediaQuery.of(context).size.height /
                                                4
                                            : MediaQuery.of(context).size.height /
                                                6,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 10.0,
                                                spreadRadius: 0.0,
                                                offset: Offset(
                                                  5.0,
                                                  5.0,
                                                ),
                                              )
                                            ],
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: widget.travels != null
                                                    ? NetworkImage(
                                                        "${dotenv.env['CDN_URL']}/assets/${widget.travels!.travels[index].image}",
                                                      )
                                                    : NetworkImage(
                                                        "${dotenv.env['CDN_URL']}/assets/${travel.travels[index].image}",
                                                      ))),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (likedList.contains(index)) {
                                                  likedList.removeWhere(
                                                      (element) =>
                                                          element == index);
                                                } else {
                                                  likedList.add(index);
                                                }
                                              });
                                            },
                                            child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                    margin: const EdgeInsets.all(
                                                        10),
                                                    padding: const EdgeInsets.all(
                                                        10),
                                                    decoration:
                                                        const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  50),
                                                            ),
                                                            color: Color.fromRGBO(
                                                                0, 0, 0, 0.3)),
                                                    child: Icon(
                                                        Icons
                                                            .favorite_border_rounded,
                                                        color: likedList
                                                                .contains(index)
                                                            ? Colors.pink
                                                            : Colors.white,
                                                        size: 20))))),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(
                                              widget.travels != null
                                                  ? toBeginningOfSentenceCase(
                                                      widget.travels!
                                                          .travels[index].name)!
                                                  : toBeginningOfSentenceCase(
                                                      travel.travels[index]
                                                          .name)!,
                                              minFontSize: 16,
                                              maxFontSize: 20,
                                              style: const TextStyle(
                                                  color: Color(0xFF0A2753))),
                                          Row(children: [
                                            const Icon(
                                              Icons.people_alt,
                                              size: 20,
                                              color: Color(0xFF0081CF),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            widget.travels != null
                                                ? AutoSizeText(
                                                    widget
                                                                .travels!
                                                                .travels[index]
                                                                .nbPepInt ==
                                                            null
                                                        ? 0.toString()
                                                        : widget
                                                            .travels!
                                                            .travels[index]
                                                            .nbPepInt
                                                            .toString(),
                                                    minFontSize: 15,
                                                    maxFontSize: 20,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF0A2753)))
                                                : AutoSizeText(
                                                    travel.travels[index]
                                                                .nbPepInt ==
                                                            null
                                                        ? 0.toString()
                                                        : travel.travels[index]
                                                            .nbPepInt
                                                            .toString(),
                                                    minFontSize: 12,
                                                    maxFontSize: 18,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF0A2753))),
                                          ])
                                        ]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 20,
                                            color: Color(0xFF0081CF),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          AutoSizeText(
                                              widget.travels != null
                                                  ? toBeginningOfSentenceCase(
                                                      widget
                                                          .travels!
                                                          .travels[index]
                                                          .location)!
                                                  : toBeginningOfSentenceCase(
                                                      travel.travels[index]
                                                          .location)!,
                                              minFontSize: 12,
                                              maxFontSize: 18,
                                              style: const TextStyle(
                                                  color: Color(0xFF0A2753))),
                                        ])
                                  ]))),
                          const SizedBox(
                            height: 40,
                          )
                        ]);
                      }).toList());
                    }

                    return const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
                  }),
            ))));
  }
}
