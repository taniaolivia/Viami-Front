part of 'group_data.dart';

LastMessage _$LastMessageFromJson(Map<String, dynamic> json) {
  return LastMessage(
    id: json['id'] as int,
    message: json['message'] as String,
    senderId: json['senderId'] as String,
    groupId: json['groupId'] as int,
    responderId: json['responderId'] as String,
    date: json['date'] as String,
    read: json['read'] as String,
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

GroupData _$GroupDataFromJson(Map<String, dynamic> json) {
  return GroupData(
    groupId: json['groupId'] as int,
    lastMessage:
        LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
    users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$GroupDataToJson(GroupData instance) => <String, dynamic>{
      'groupId': instance.groupId,
      'lastMessage': instance.lastMessage.toJson(),
      'users': instance.users,
    };
