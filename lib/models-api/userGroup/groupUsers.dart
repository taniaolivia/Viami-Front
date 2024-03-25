import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/userGroup/groupUser.dart';

part 'groupUsers.g.dart';

@JsonSerializable()
class GroupUsers {
  GroupUsers({required this.groupUsers});

  factory GroupUsers.fromJson(Map<String?, dynamic> json) =>
      _$GroupUsersFromJson(json);
  Map<String?, dynamic> toJson() => _$GroupUsersToJson(this);

  final List<GroupUser> groupUsers;
}
