import 'package:flutter/material.dart';
import '../components/travelComponent.dart';

class TravelPageDetails extends StatefulWidget {
  final String travelId;
  const TravelPageDetails({Key? key, required this.travelId}) : super(key: key);

  @override
  State<TravelPageDetails> createState() => _TravelPageDetailsState();
}

class _TravelPageDetailsState extends State<TravelPageDetails> {
  @override
  Widget build(BuildContext context) {
    return TravelComponent(
      travelId: widget.travelId,
      isRecommended: false,
    );
  }
}
