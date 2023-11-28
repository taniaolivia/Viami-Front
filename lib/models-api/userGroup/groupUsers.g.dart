part of 'groupUsers.dart';

GroupUsers _$GroupUsersFromJson(Map<String?, dynamic> json) => GroupUsers(
      groupUsers: (json['groupUsers'] as List<dynamic>)
          .map((e) => GroupUser.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$GroupUsersToJson(GroupUsers instance) =>
    <String?, dynamic>{'groupUsers': instance.groupUsers};
