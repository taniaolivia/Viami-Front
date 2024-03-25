part of 'users.dart';

Users _$UsersFromJson(Map<String?, dynamic> json) => Users(
      users: (json['data'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$UsersToJson(Users instance) =>
    <String?, dynamic>{'data': instance.users};
