import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/comment/comment.dart';

part 'comments.c.dart';

@JsonSerializable()
class Comments {
  Comments({required this.comments});

  factory Comments.fromJson(Map<String?, dynamic> json) =>
      _$CommentsFromJson(json);
  Map<String?, dynamic> toJson() => _$CommentsToJson(this);

  final List<Comment> comments;
}
