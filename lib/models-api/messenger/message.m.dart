part of 'message.dart';

Message _$MessageFromJson(Map<String?, dynamic> json) => Message(
    id: json['id'],
    senderId: json['senderId'],
    responderId: json['responderId'],
    groupId: json['groupId'],
    senderFirstName: json['senderFirstName'],
    senderLastName: json['senderLastName'],
    responderFirstName: json['responderFirstName'],
    responderLastName: json['responderLastName'],
    message: json["message"],
    date: json['date'],
    read: json['read']);

Map<String?, dynamic> _$MessageToJson(Message instance) => <String?, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'responderId': instance.responderId,
      'groupId': instance.groupId,
      'senderFirstName': instance.senderFirstName,
      'senderLastName': instance.senderLastName,
      'responderFirstName': instance.responderFirstName,
      'responderLastName': instance.responderLastName,
      'message': instance.message,
      'date': instance.date,
      'read': instance.read
    };
