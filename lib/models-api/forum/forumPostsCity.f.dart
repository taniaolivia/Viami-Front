part of 'forumPostsCity.dart';

ForumPostsCity _$ForumPostsCityFromJson(Map<String?, dynamic> json) =>
    ForumPostsCity(
      forumPostsCities: (json['forum_posts_cities'] as List<dynamic>)
          .map((e) => ForumPostCity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$ForumPostsCityToJson(ForumPostsCity instance) =>
    <String?, dynamic>{'forum_posts_cities': instance.forumPostsCities};
