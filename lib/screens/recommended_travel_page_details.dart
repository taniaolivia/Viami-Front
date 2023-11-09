import 'package:flutter/material.dart';

import '../components/travelComponent.dart';

class RecommendedTravelPageDetails extends StatefulWidget {
  final String travelId;
  const RecommendedTravelPageDetails({Key? key, required this.travelId})
      : super(key: key);

  @override
  State<RecommendedTravelPageDetails> createState() =>
      _RecommendedTravelPageDetailsState();
}

class _RecommendedTravelPageDetailsState
    extends State<RecommendedTravelPageDetails> {
  @override
  Widget build(BuildContext context) {
    return TravelComponent(
      travelId: widget.travelId,
      isRecommended: true,
    );
  }
}
