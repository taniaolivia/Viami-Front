import 'package:json_annotation/json_annotation.dart';

part 'travelActivity.a.dart';

@JsonSerializable()
class TravelActivity {
  TravelActivity({this.id, required this.idTravel, this.idActivity});

  factory TravelActivity.fromJson(Map<String?, dynamic> json) =>
      _$TravelActivityFromJson(json);
  Map<String?, dynamic> toJson() => _$TravelActivityToJson(this);

  final String? id;
  final String idTravel;
  final String? idActivity;
}
