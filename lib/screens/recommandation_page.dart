import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../components/recommanded_card.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({Key? key}) : super(key: key);

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
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
                    child: ListView(
                      children: const [
                        RecommandedCrd(
                          destination: 'Destination 1',
                          location: 'location 1',
                          imagePath: 'profil.png',
                          interestedPeople: 5,
                        ),
                        RecommandedCrd(
                          destination: 'Destination 2',
                          location: 'location 2',
                          imagePath: 'profil.png',
                          interestedPeople: 10,
                        ),
                      ],
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
