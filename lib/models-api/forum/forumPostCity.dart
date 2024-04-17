import 'package:json_annotation/json_annotation.dart';

part 'forumPostCity.f.dart';

@JsonSerializable()
class ForumPostCity {
  final int id;
  final String post;
  final Map<String, dynamic> user;
  final Map<String, dynamic> city;
  final String postedOn;

  ForumPostCity({
    required this.id,
    required this.post,
    required this.user,
    required this.city,
    required this.postedOn,
  });

  factory ForumPostCity.fromJson(Map<String, dynamic> json) =>
      _$ForumPostCityFromJson(json);

  Map<String, dynamic> toJson() => _$ForumPostCityToJson(this);
}
