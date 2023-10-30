part of 'comment.dart';

Comment _$CommentFromJson(Map<String?, dynamic> json) => Comment(
      id: json['id'],
      comment: json['comment'],
    );

Map<String?, dynamic> _$CommentToJson(Comment instance) => <String?, dynamic>{
      'id': instance.id,
      'image': instance.comment,
    };
