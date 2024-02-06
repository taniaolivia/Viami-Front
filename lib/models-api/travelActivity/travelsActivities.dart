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
      this.activityNbParticipant,
      this.activityUrl,
      this.activityTelephone,
      this.activityAddress,
      this.activityLatitude,
      this.activityLongitude,
      this.activitySchedule,
      this.activityLanguage,
      this.activityAccessibility});

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
  final String? activityUrl;
  final String? activityTelephone;
  final String? activityAddress;
  final String? activityLatitude;
  final String? activityLongitude;
  final String? activitySchedule;
  final String? activityLanguage;
  final String? activityAccessibility;
}

class TravelsActivities {
  TravelsActivities({required this.travelActivities});

  factory TravelsActivities.fromJson(Map<String?, dynamic> json) =>
      _$TravelsActivitiesFromJson(json);
  Map<String?, dynamic> toJson() => _$TravelsActivitiesToJson(this);

  final List<TravelActivity> travelActivities;
}
