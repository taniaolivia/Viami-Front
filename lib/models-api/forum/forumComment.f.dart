part of 'forumComment.dart';

ForumComment _$ForumCommentFromJson(Map<String, dynamic> json) => ForumComment(
    id: json['id'],
    forumId: json['forumId'],
    comment: json['comment'],
    user: json['user'],
    commentedOn: json['commentedOn']);

Map<String, dynamic> _$ForumCommentToJson(ForumComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'forumId': instance.forumId,
      'comment': instance.comment,
      'image': instance.user,
      'commentedOn': instance.commentedOn
    };
