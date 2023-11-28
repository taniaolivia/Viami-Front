part of 'userStatus.dart';

UserStatus _$UserStatusFromJson(Map<String?, dynamic> json) =>
    UserStatus(status: json['status'], lastConnection: json['lastConnection']);

Map<String?, dynamic> _$UserStatusToJson(UserStatus instance) =>
    <String?, dynamic>{
      'status': instance.status,
      'lastConnection': instance.lastConnection,
    };
