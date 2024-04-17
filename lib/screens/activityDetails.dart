import 'package:flutter/material.dart';
import 'package:viami/components/activityComponent.dart';

class ActivityDetailsPage extends StatefulWidget {
  final int activityId;
  const ActivityDetailsPage({Key? key, required this.activityId})
      : super(key: key);

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return ActivityComponent(activityId: widget.activityId);
  }
}
