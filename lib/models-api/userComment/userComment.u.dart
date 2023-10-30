part of 'userComment.dart';

UserComment _$UserCommentFromJson(Map<String?, dynamic> json) => UserComment(
    id: json['id'],
    commentId: json['commentId'],
    userId: json["userId"],
    commenterId: json["commenterId"]);

Map<String?, dynamic> _$UserCommentToJson(UserComment instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'commentId': instance.commentId,
      'userId': instance.userId,
      'commenterId': instance.commenterId
    };
