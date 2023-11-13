import 'package:json_annotation/json_annotation.dart';

part 'travelsActivities.a.dart';

@JsonSerializable()
class TravelActivity {
  TravelActivity(
      {required this.id,
      required this.idActivity,
      required this.idTravel,
      required this.name,
      required this.travelDescription,
      required this.location,
      this.nbParticipant,
      required this.activityName,
      required this.imageName,
      required this.activityLocation,
      required this.isRecommended,
      this.activityNbParticipant});

  factory TravelActivity.fromJson(Map<String?, dynamic> json) =>
      _$TravelActivityFromJson(json);
  Map<String?, dynamic> toJson() => _$TravelActivityToJson(this);

  final int id;
  final int idActivity;
  final int idTravel;
  final String name;
  final String travelDescription;
  final String location;
  final int? nbParticipant;
  final String activityName;
  final String imageName;
  final String activityLocation;
  final int isRecommended;
  final int? activityNbParticipant;
}

class TravelsActivities {
  TravelsActivities({required this.travelActivities});

  factory TravelsActivities.fromJson(Map<String?, dynamic> json) =>
      _$TravelsActivitiesFromJson(json);
  Map<String?, dynamic> toJson() => _$TravelsActivitiesToJson(this);

  final List<TravelActivity> travelActivities;
}
