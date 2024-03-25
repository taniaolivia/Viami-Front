import 'package:json_annotation/json_annotation.dart';

part 'activityImage.a.dart';

@JsonSerializable()
class ActivityImage {
  ActivityImage({this.id, required this.idActivity, this.idImage});

  factory ActivityImage.fromJson(Map<String?, dynamic> json) =>
      _$ActivityImageFromJson(json);
  Map<String?, dynamic> toJson() => _$ActivityImageToJson(this);

  final String? id;
  final String idActivity;
  final String? idImage;
}
