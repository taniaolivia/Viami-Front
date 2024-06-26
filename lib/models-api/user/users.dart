import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/user/user.dart';

part 'users.u.dart';

@JsonSerializable()
class Users {
  Users({required this.users});

  factory Users.fromJson(Map<String?, dynamic> json) => _$UsersFromJson(json);
  Map<String?, dynamic> toJson() => _$UsersToJson(this);

  final List<User> users;
}
