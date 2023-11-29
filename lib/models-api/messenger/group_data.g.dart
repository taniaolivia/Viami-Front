part of 'group_data.dart';

LastMessage _$LastMessageFromJson(Map<String, dynamic> json) {
  return LastMessage(
    id: json['id'],
    message: json['message'],
    senderId: json['senderId'],
    groupId: json['groupId'],
    responderId: json['responderId'],
    date: json['date'],
    read: json['read'],
    senderFirstName: json['senderFirstName'],
    senderLastName: json['senderLastName'],
    responderFirstName: json['responderFirstName'],
    responderLastName: json['responderLastName'],
  );
}

Map<String, dynamic> _$LastMessageToJson(LastMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'senderId': instance.senderId,
      'groupId': instance.groupId,
      'responderId': instance.responderId,
      'date': instance.date,
      'read': instance.read,
      'senderFirstName': instance.senderFirstName,
      'senderLastName': instance.senderLastName,
      'responderFirstName': instance.responderFirstName,
      'responderLastName': instance.responderLastName,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
      id: json['id'], firstName: json['firstName'], lastName: json['lastName']);
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

GroupData _$GroupDataFromJson(Map<String, dynamic> json) {
  return GroupData(
    groupId: json['groupId'] as int,
    lastMessage:
        LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
    users: (json['users'] as List<dynamic>)
        .map((e) => UserData.fromJson(e as Map<String, dynamic>))
        .toList(),
    usersRead:
        (json['usersRead'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$GroupDataToJson(GroupData instance) => <String, dynamic>{
      'groupId': instance.groupId,
      'lastMessage': instance.lastMessage.toJson(),
      'users': instance.users,
      'usersRead': instance.usersRead
    };
