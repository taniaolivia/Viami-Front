import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/travel/travels.dart';

import '../components/recommanded_card.dart';
import '../models-api/travel/travel.dart';
import '../services/travel/recommendedTravel.service.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({Key? key}) : super(key: key);

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final storage = const FlutterSecureStorage();

  String? token = "";
  late Future<Travels> _recommendedTravels;
  String? redirect = "/home";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<Travels> getListRecommendedTravels() {
      Future<Travels> getAllRTravels() async {
        token = await storage.read(key: "token");
        print(token);
        return RecommendedTravelsService()
            .getAllRecommendedTravels(token.toString());
      }

      return getAllRTravels();
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/recomendation.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: IconButton(
                              onPressed: () {
                                redirect != null
                                    ? Navigator.pushNamed(context, redirect!)
                                    : Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                                size: 20,
                              )))),
                  SizedBox(height: 16.0),
                  AutoSizeText(
                    "NOS RECOMMANDATIONS",
                    minFontSize: 20,
                    maxFontSize: 24,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 20.0,
                            spreadRadius: 5.0,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 180.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  Expanded(
                    child: FutureBuilder<Travels>(
                      future: getListRecommendedTravels(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.travels.isEmpty) {
                          return Text('No recommended travels available.');
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.travels.length,
                            itemBuilder: (context, index) {
                              var travel = snapshot.data!.travels[index];
                              return RecommandedCrd(
                                destination: travel.name,
                                location: travel.location,
                                imagePath: travel.image,
                                interestedPeople: travel.nbPepInt ?? 0,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
