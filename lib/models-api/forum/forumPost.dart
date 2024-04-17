import 'package:json_annotation/json_annotation.dart';

part 'forumPost.f.dart';

@JsonSerializable()
class ForumPost {
  final int id;
  final String post;
  final Map<String, dynamic> user;
  final String postedOn;

  ForumPost({
    required this.id,
    required this.post,
    required this.user,
    required this.postedOn,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) =>
      _$ForumPostFromJson(json);

  Map<String, dynamic> toJson() => _$ForumPostToJson(this);
}
