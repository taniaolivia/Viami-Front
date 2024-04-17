part of 'groups_data.dart';

Groups _$GroupsFromJson(Map<String, dynamic> json) {
  return Groups(
    groups: (json['discussions'] as List<dynamic>)
        .map((e) => GroupData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$GroupsToJson(Groups instance) => <String, dynamic>{
      'discussions': instance.groups.map((e) => e.toJson()).toList(),
    };
