import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RecommandedCrd extends StatefulWidget {
  final String destination;
  final String location;
  final String imagePath;
  final String? interestedPeople;

  const RecommandedCrd({
    Key? key,
    required this.destination,
    required this.location,
    required this.imagePath,
    required this.interestedPeople,
  }) : super(key: key);

  @override
  State<RecommandedCrd> createState() => _RecommandedCrdState();
}

class _RecommandedCrdState extends State<RecommandedCrd> {
  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width - 40;

    return Card(
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
                    child: Image.asset(
                      'assets/icon_recommended.png',
                      width: 32.0,
                      height: 32.0,
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
                        fontFamily: "Montserrat",
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
                        Text(
                          '${widget.interestedPeople}',
                          style: const TextStyle(
                            color: Color(0xFF6A778B),
                          ),
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
                    Text(
                      widget.location,
                      style: const TextStyle(
                        color: Color(0xFF6A778B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
