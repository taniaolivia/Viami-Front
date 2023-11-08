import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/travel/travel.dart';

part 'travels.u.dart';

@JsonSerializable()
class Travels {
  Travels({required this.travels});

  factory Travels.fromJson(Map<String?, dynamic> json) =>
      _$TravelsFromJson(json);
  Map<String?, dynamic> toJson() => _$TravelsToJson(this);

  final List<Travel> travels;
}
