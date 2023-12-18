import 'package:json_annotation/json_annotation.dart';

part 'request_message_r.dart';

@JsonSerializable()
class RequestMessage {
  final int id;
  final String requesterId;
  final String receiverId;
  final String requesterFirstName;
  final String requesterLastName;
  final String receiverFirstName;
  final String receiverLastName;
  final String? requesterFcmToken;
  final String? receiverFcmToken;
  final int? accept;
  final int chat;

  RequestMessage({
    required this.id,
    required this.requesterId,
    required this.receiverId,
    required this.requesterFirstName,
    required this.requesterLastName,
    required this.receiverFirstName,
    required this.receiverLastName,
    this.requesterFcmToken,
    this.receiverFcmToken,
    this.accept,
    required this.chat,
  });

  factory RequestMessage.fromJson(Map<String?, dynamic> json) =>
      _$RequestMessageFromJson(json);
  Map<String?, dynamic> toJson() => _$RequestMessageToJson(this);
}
