import 'package:json_annotation/json_annotation.dart';

part 'forumComment.f.dart';

@JsonSerializable()
class ForumComment {
  final int id;
  final int forumId;
  final String comment;
  final Map<String, dynamic> user;
  final String commentedOn;

  ForumComment({
    required this.id,
    required this.forumId,
    required this.comment,
    required this.user,
    required this.commentedOn,
  });

  factory ForumComment.fromJson(Map<String, dynamic> json) =>
      _$ForumCommentFromJson(json);

  Map<String, dynamic> toJson() => _$ForumCommentToJson(this);
}
