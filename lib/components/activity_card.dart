import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 200,
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
                    image: NetworkImage(activity.image),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              AutoSizeText(
                activity.name,
                style: TextStyle(
                  color: Color(0xFF0A2753),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                ),
                minFontSize: 13,
                maxFontSize: 15,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Color(0xFF0081CF),
                  ),
                  AutoSizeText(
                    activity.location,
                    style: TextStyle(
                        color: Color(0xFF6A778B),
                        fontWeight: FontWeight.normal,
                        fontFamily: "Montserrat"),
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
