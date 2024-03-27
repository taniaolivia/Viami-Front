part of 'forumCity.dart';

ForumCity _$ForumCityFromJson(Map<String, dynamic> json) =>
    ForumCity(id: json['id'], city: json['city'], image: json['image']);

Map<String, dynamic> _$ForumCityToJson(ForumCity instance) => <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'image': instance.image
    };
