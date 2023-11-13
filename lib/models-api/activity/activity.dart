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
      this.nbParticipant,
      this.description});

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
}
