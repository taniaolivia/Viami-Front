import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/image/image.dart';

part 'forumCity.f.dart';

@JsonSerializable()
class ForumCity {
  ForumCity({required this.id, required this.city, required this.image});

  final int id;
  final String city;
  final Map<String, dynamic> image;

  factory ForumCity.fromJson(Map<String, dynamic> json) =>
      _$ForumCityFromJson(json);

  Map<String, dynamic> toJson() => _$ForumCityToJson(this);
}
