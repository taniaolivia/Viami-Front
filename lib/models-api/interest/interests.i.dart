part of 'interests.dart';

Interests _$InterestsFromJson(Map<String?, dynamic> json) => Interests(
      interests: (json['interests'] as List<dynamic>)
          .map((e) => Interest.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$InterestsToJson(Interests instance) =>
    <String?, dynamic>{'interests': instance.interests};
