part of 'forumPost.dart';

ForumPost _$ForumPostFromJson(Map<String, dynamic> json) => ForumPost(
    id: json['id'],
    post: json['post'],
    user: json['user'],
    postedOn: json['postedOn']);

Map<String, dynamic> _$ForumPostToJson(ForumPost instance) => <String, dynamic>{
      'id': instance.id,
      'post': instance.post,
      'user': instance.user,
      'postedOn': instance.postedOn
    };
