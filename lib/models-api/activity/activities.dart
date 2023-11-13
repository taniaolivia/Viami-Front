import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/activity/activity.dart';

part 'activities.a.dart';

@JsonSerializable()
class Activities {
  Activities({required this.activities});

  factory Activities.fromJson(Map<String?, dynamic> json) =>
      _$ActivitiesFromJson(json);
  Map<String?, dynamic> toJson() => _$ActivitiesToJson(this);

  final List<Activity> activities;
}
