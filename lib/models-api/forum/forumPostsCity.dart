import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/forum/forumPostCity.dart';

part 'forumPostsCity.f.dart';

@JsonSerializable()
class ForumPostsCity {
  ForumPostsCity({
    required this.forumPostsCities,
  });

  final List<ForumPostCity> forumPostsCities;

  factory ForumPostsCity.fromJson(Map<String, dynamic> json) =>
      _$ForumPostsCityFromJson(json);

  Map<String?, dynamic> toJson() => _$ForumPostsCityToJson(this);
}
