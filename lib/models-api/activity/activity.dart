import 'package:json_annotation/json_annotation.dart';

part 'activity.a.dart';

@JsonSerializable()
class Activity {
  Activity(
      {required this.id,
      required this.name,
      required this.imageName,
      required this.location,
      required this.isRecommended,
      this.url,
      this.telephone,
      this.address,
      this.latitude,
      this.longitude,
      this.schedule,
      this.language,
      this.accessibility,
      this.nbParticipant,
      this.description,
      this.note});

  factory Activity.fromJson(Map<String?, dynamic> json) =>
      _$ActivityFromJson(json);
  Map<String?, dynamic> toJson() => _$ActivityToJson(this);

  final int id;
  final String name;
  final String location;
  final String imageName;
  final int isRecommended;
  final int? nbParticipant;
  final String? description;
  final String? note;
  final String? url;
  final String? telephone;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? schedule;
  final String? language;
  final String? accessibility;
}
