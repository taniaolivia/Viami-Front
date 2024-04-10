part of 'messageUser.dart';

MessageUser _$MessageUserFromJson(Map<String?, dynamic> json) => MessageUser(
      groupId: json['groupId'],
      message: json['message'],
      senderId: json['senderId'],
      responderId: json['responderId'],
    );

Map<String?, dynamic> _$MessageUserToJson(MessageUser instance) =>
    <String?, dynamic>{
      'groupId': instance.groupId,
      'message': instance.message,
      'senderId': instance.senderId,
      'responderId': instance.responderId,
    };
