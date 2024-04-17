import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/messenger/group_data.dart';

part 'groups_data.g.dart';

@JsonSerializable()
class Groups {
  final List<GroupData> groups;

  Groups({
    required this.groups,
  });

  factory Groups.fromJson(Map<String, dynamic> json) => _$GroupsFromJson(json);

  Map<String, dynamic> toJson() => _$GroupsToJson(this);
}
