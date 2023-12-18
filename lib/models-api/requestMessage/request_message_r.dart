part of 'request_message.dart';

RequestMessage _$RequestMessageFromJson(Map<String?, dynamic> json) =>
    RequestMessage(
        id: json['id'],
        requesterId: json['requesterId'],
        receiverId: json['receiverId'],
        requesterFirstName: json["requesterFirstName"],
        requesterLastName: json["requesterLastName"],
        receiverFirstName: json["receiverFirstName"],
        receiverLastName: json["receiverLastName"],
        requesterFcmToken: json["requesterFcmToken"],
        receiverFcmToken: json["receiverFcmToken"],
        accept: json["accept"],
        chat: json["chat"]);

Map<String?, dynamic> _$RequestMessageToJson(RequestMessage instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'requesterId': instance.requesterId,
      'receiverId': instance.receiverId,
      'requesterFirstName': instance.requesterFirstName,
      'requesterLastName': instance.requesterLastName,
      'receiverFirstName': instance.receiverFirstName,
      'receiverLastName': instance.receiverLastName,
      'requesterFcmToken': instance.requesterFcmToken,
      'receiverFcmToken': instance.receiverFcmToken,
      'accept': instance.accept,
      'chat': instance.chat
    };
