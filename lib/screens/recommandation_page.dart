import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
  final RecommendedTravelsService _recommendedTravelsService =
      RecommendedTravelsService();
  late Future<Travels> _recommendedTravels;

  @override
  void initState() {
    super.initState();
    _recommendedTravels = _recommendedTravelsService.getAllRecommendedTravels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/recomendation.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 120.0,
            left: 98,
            right: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    AutoSizeText(
                      "NOS RECOMMANDATIONS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      ),
                      minFontSize: 20.0,
                      maxFontSize: 24.0,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
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
                      future: _recommendedTravels,
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
                                imagePath: 'profil.png',
                                interestedPeople: travel.nbPepInt ?? '0',
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
