part of 'message.dart';

Message _$MessageFromJson(Map<String?, dynamic> json) => Message(
    id: json['id'],
    senderId: json['senderId'] as String,
    groupId: json['groupId'] as int,
    responderId: json['responderId'] as String,
    senderFirstName: json['senderFirstName'],
    senderLastName: json['senderLastName'],
    responderFirstName: json['responderFirstName'],
    responderLastName: json['responderLastName'],
    message: json["message"] as String,
    date: json['date'] as String,
    read: json['read'] as String);

Map<String?, dynamic> _$MessageToJson(Message instance) => <String?, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'groupId': instance.groupId,
      'responderId': instance.responderId,
      'senderFirstName': instance.senderFirstName,
      'senderLastName': instance.senderLastName,
      'responderFirstName': instance.responderFirstName,
      'responderLastName': instance.responderLastName,
      'message': instance.message,
      'date': instance.date,
      'read': instance.read
    };
