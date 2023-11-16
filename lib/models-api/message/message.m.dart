part of 'message.dart';

Message _$MessageFromJson(Map<String?, dynamic> json) => Message(
      id: json['id'],
      message: json['message'],
      senderId: json['senderId'],
      responderId: json['responderId'],
      date: json['date'],
      read: json['read'],
    );

Map<String?, dynamic> _$MessageToJson(Message instance) => <String?, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'senderId': instance.senderId,
      'responderId': instance.responderId,
      'date': instance.date,
      'read': instance.read,
    };
