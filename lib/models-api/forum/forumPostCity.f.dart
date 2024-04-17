part of 'forumPostCity.dart';

ForumPostCity _$ForumPostCityFromJson(Map<String, dynamic> json) =>
    ForumPostCity(
        id: json['id'],
        post: json['post'],
        user: json['user'],
        city: json['city'],
        postedOn: json['postedOn']);

Map<String, dynamic> _$ForumPostCityToJson(ForumPostCity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post': instance.post,
      'user': instance.user,
      'city': instance.city,
      'postedOn': instance.postedOn
    };
