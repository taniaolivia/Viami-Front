import 'package:json_annotation/json_annotation.dart';

part 'userComment.u.dart';

@JsonSerializable()
class UserComment {
  UserComment(
      {this.id, required this.commentId, this.userId, this.commenterId});

  factory UserComment.fromJson(Map<String?, dynamic> json) =>
      _$UserCommentFromJson(json);
  Map<String?, dynamic> toJson() => _$UserCommentToJson(this);

  final String? id;
  final String commentId;
  final String? userId;
  final String? commenterId;
}
