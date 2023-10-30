import 'package:json_annotation/json_annotation.dart';

part 'comment.c.dart';

@JsonSerializable()
class Comment {
  Comment({this.id, required this.comment});

  factory Comment.fromJson(Map<String?, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String?, dynamic> toJson() => _$CommentToJson(this);

  final int? id;
  final String comment;
}
