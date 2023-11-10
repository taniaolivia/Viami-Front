import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:viami/components/pageTransition.dart';

import '../screens/recommended_travel_page_details.dart';
import '../screens/travel_page_details.dart';

class RecommandedCrd extends StatefulWidget {
  final String id;
  final String destination;
  final String location;
  final String imagePath;
  final int? interestedPeople;

  const RecommandedCrd({
    Key? key,
    required this.destination,
    required this.location,
    required this.imagePath,
    required this.interestedPeople,
    required this.id,
  }) : super(key: key);

  @override
  State<RecommandedCrd> createState() => _RecommandedCrdState();
}

class _RecommandedCrdState extends State<RecommandedCrd> {
  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width - 40;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          FadePageRoute(
            page: RecommendedTravelPageDetails(travelId: widget.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: const Color(0xFFEDEEEF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.asset(
                      'assets/${widget.imagePath}',
                      width: cardWidth,
                      height: 160.0,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40),
                            ),
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                          ),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        widget.destination,
                        style: const TextStyle(
                          color: Color(0xFF0A2753),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                        minFontSize: 20,
                        maxFontSize: 22,
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 4.0),
                          AutoSizeText(
                            '${widget.interestedPeople}',
                            style: const TextStyle(
                              color: Color(0xFF6A778B),
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                            ),
                            minFontSize: 18,
                            maxFontSize: 20,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 4.0),
                      AutoSizeText(
                        widget.location,
                        style: const TextStyle(
                          color: Color(0xFF6A778B),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                        minFontSize: 18,
                        maxFontSize: 20,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
