part of 'forumCities.dart';

ForumCities _$ForumCitiesFromJson(Map<String?, dynamic> json) => ForumCities(
      forumCities: (json['forum_cities'] as List<dynamic>)
          .map((e) => ForumCity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$ForumCitiesToJson(ForumCities instance) =>
    <String?, dynamic>{'forum_cities': instance.forumCities};
