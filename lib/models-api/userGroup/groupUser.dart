import 'package:json_annotation/json_annotation.dart';

part 'groupUser.g.dart';

@JsonSerializable()
class GroupUser {
  GroupUser(
      {required this.id,
      required this.userId,
      required this.groupId,
      required this.firstName,
      required this.lastName});

  factory GroupUser.fromJson(Map<String?, dynamic> json) =>
      _$GroupUserFromJson(json);
  Map<String?, dynamic> toJson() => _$GroupUserToJson(this);

  final int id;
  final String userId;
  final int groupId;
  final String firstName;
  final String lastName;
}
