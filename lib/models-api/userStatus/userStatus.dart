import 'package:json_annotation/json_annotation.dart';
part 'userStatus.s.dart';

@JsonSerializable()
class UserStatus {
  UserStatus({this.status, required this.lastConnection});

  factory UserStatus.fromJson(Map<String?, dynamic> json) =>
      _$UserStatusFromJson(json);
  Map<String?, dynamic> toJson() => _$UserStatusToJson(this);

  final String? status;
  final String lastConnection;
}
