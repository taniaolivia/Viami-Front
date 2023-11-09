import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/services/travelActivity/travelsActivities.service.dart';

import '../components/activityComponent.dart';
import '../components/activity_card.dart';
import '../models-api/travel/travel.dart';
import '../models-api/travelActivity/travelsActivities.dart';
import '../models/activity.dart';
import '../services/travel/travels.service.dart';
import '../services/travelImage/travelsImages.service.dart';
import '../widgets/expandable_text_widget.dart';
import '../widgets/icon_and_text_widget.dart';

class TravelPageDetails extends StatefulWidget {
  final String travelId;
  const TravelPageDetails({Key? key, required this.travelId}) : super(key: key);

  @override
  State<TravelPageDetails> createState() => _TravelPageDetailsState();
}

class _TravelPageDetailsState extends State<TravelPageDetails> {
  @override
  Widget build(BuildContext context) {
    return ActivityComponent(
      travelId: widget.travelId,
      isRecommended: true,
    );
  }
}
