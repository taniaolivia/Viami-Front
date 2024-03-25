part of 'send_message.dart';

Sendmessage _$SendmessageFromJson(Map<String?, dynamic> json) => Sendmessage(
      groupId: json['groupId'],
      message: json['message'],
      senderId: json['senderId'],
      responderId: json['responderId'],
    );

Map<String?, dynamic> _$SendmessageToJson(Sendmessage instance) =>
    <String?, dynamic>{
      'groupId': instance.groupId,
      'message': instance.message,
      'senderId': instance.senderId,
      'responderId': instance.responderId,
    };
