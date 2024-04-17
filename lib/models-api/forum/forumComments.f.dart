part of 'forumComments.dart';

ForumComments _$ForumCommentsFromJson(Map<String?, dynamic> json) =>
    ForumComments(
      forumComments: (json['forum_comment'] as List<dynamic>)
          .map((e) => ForumComment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$ForumCommentsToJson(ForumComments instance) =>
    <String?, dynamic>{'forum_comment': instance.forumComments};
