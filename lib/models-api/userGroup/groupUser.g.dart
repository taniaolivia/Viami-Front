part of 'groupUser.dart';

GroupUser _$GroupUserFromJson(Map<String?, dynamic> json) => GroupUser(
      id: json['id'],
      userId: json['userId'],
      groupId: json['groupId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );

Map<String?, dynamic> _$GroupUserToJson(GroupUser instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'groupId': instance.groupId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };
