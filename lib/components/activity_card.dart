import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:viami/models-api/travelActivity/travelsActivities.dart';

class ActivityCard extends StatelessWidget {
  final TravelActivity activity;

  const ActivityCard({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        '${dotenv.env['CDN_URL']}/assets/${activity.imageName}'),
                  ),
                ),
                child: GestureDetector(
                    onTap: () {},
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(40),
                                ),
                                color: Color.fromRGBO(0, 0, 0, 0.3)),
                            child: const Icon(Icons.favorite_border_rounded,
                                color: Colors.white, size: 15)))),
              ),
              const SizedBox(
                height: 8.0,
              ),
              AutoSizeText(
                toBeginningOfSentenceCase(activity.activityName)!,
                style: const TextStyle(
                  color: Color(0xFF0A2753),
                  fontWeight: FontWeight.bold,
                ),
                minFontSize: 13,
                maxFontSize: 15,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF0081CF),
                  ),
                  AutoSizeText(
                    activity.activityLocation,
                    style: const TextStyle(
                      color: Color(0xFF6A778B),
                      fontWeight: FontWeight.normal,
                    ),
                    minFontSize: 12,
                    maxFontSize: 13,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
