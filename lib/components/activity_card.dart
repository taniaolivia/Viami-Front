import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/pageTransition.dart';
import 'package:viami/models-api/travelActivity/travelsActivities.dart';
import 'package:viami/screens/activityDetails.dart';

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
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                FadePageRoute(
                    page: ActivityDetailsPage(activityId: activity.id)));
          },
          child: UnconstrainedBox(
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(activity.imageName),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 10.0, right: 15.0),
                      child: AutoSizeText(
                        toBeginningOfSentenceCase(activity.activityName)!,
                        style: const TextStyle(
                          color: Color(0xFF0A2753),
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 13,
                        maxFontSize: 15,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 10.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF0081CF),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          AutoSizeText(
                            activity.activityLocation,
                            style: const TextStyle(
                              color: Color(0xFF6A778B),
                              fontWeight: FontWeight.normal,
                            ),
                            minFontSize: 12,
                            maxFontSize: 13,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
