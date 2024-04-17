import 'package:json_annotation/json_annotation.dart';

part 'travel.t.dart';

@JsonSerializable()
class Travel {
  Travel(
      {required this.id,
      required this.name,
      this.description,
      required this.location,
      required this.image,
      this.nbParticipant});

  factory Travel.fromJson(Map<String?, dynamic> json) => _$TravelFromJson(json);
  Map<String?, dynamic> toJson() => _$TravelToJson(this);

  final int id;
  final String name;
  final String? description;
  final String location;
  final String image;
  final int? nbParticipant;
}
