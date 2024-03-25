part of 'comments.dart';

Comments _$CommentsFromJson(Map<String?, dynamic> json) => Comments(
      comments: (json['comments'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$CommentsToJson(Comments instance) =>
    <String?, dynamic>{'comments': instance.comments};
