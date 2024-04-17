import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/forum/forumCity.dart';

part 'forumCities.f.dart';

@JsonSerializable()
class ForumCities {
  ForumCities({
    required this.forumCities,
  });

  final List<ForumCity> forumCities;

  factory ForumCities.fromJson(Map<String, dynamic> json) =>
      _$ForumCitiesFromJson(json);

  Map<String?, dynamic> toJson() => _$ForumCitiesToJson(this);
}
