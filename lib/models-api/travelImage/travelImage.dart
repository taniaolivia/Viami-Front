import 'package:json_annotation/json_annotation.dart';

part 'travelImage.i.dart';

@JsonSerializable()
class TravelImage {
  TravelImage({this.id, required this.idTravel, this.idImage});

  factory TravelImage.fromJson(Map<String?, dynamic> json) =>
      _$TravelImageFromJson(json);
  Map<String?, dynamic> toJson() => _$TravelImageToJson(this);

  final String? id;
  final String idTravel;
  final String? idImage;
}
