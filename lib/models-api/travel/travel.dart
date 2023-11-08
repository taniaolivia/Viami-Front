import 'package:json_annotation/json_annotation.dart';
part 'travel.u.dart';

@JsonSerializable()
class Travel {
  Travel(
      {this.id,
      required this.name,
      required this.description,
      required this.location,
      this.nbPepInt,
      required this.isRecommended});

  factory Travel.fromJson(Map<String?, dynamic> json) => _$TravelFromJson(json);
  Map<String?, dynamic> toJson() => _$TravelToJson(this);

  final String? id;
  final String name;
  final String? description;
  final String location;
  final String? nbPepInt;
  final bool isRecommended;
}
