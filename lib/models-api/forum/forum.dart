import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/forum/forumPost.dart';

part 'forum.f.dart';

@JsonSerializable()
class Forum {
  Forum({
    required this.forum,
  });

  final List<ForumPost> forum;

  factory Forum.fromJson(Map<String, dynamic> json) => _$ForumFromJson(json);

  Map<String?, dynamic> toJson() => _$ForumToJson(this);
}
