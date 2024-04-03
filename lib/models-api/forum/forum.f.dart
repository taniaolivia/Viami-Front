part of 'forum.dart';

Forum _$ForumFromJson(Map<String?, dynamic> json) => Forum(
      forum: (json['forum'] as List<dynamic>)
          .map((e) => ForumPost.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$ForumToJson(Forum instance) =>
    <String?, dynamic>{'forum': instance.forum};
