import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/forum/forumComment.dart';

part 'forumComments.f.dart';

@JsonSerializable()
class ForumComments {
  ForumComments({
    required this.forumComments,
  });

  final List<ForumComment> forumComments;

  factory ForumComments.fromJson(Map<String, dynamic> json) =>
      _$ForumCommentsFromJson(json);

  Map<String?, dynamic> toJson() => _$ForumCommentsToJson(this);
}
