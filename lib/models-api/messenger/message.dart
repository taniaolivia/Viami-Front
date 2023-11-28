import 'package:json_annotation/json_annotation.dart';

part 'message.m.dart';

@JsonSerializable()
class Message {
  Message(
      {required this.id,
      required this.senderId,
      required this.groupId,
      required this.responderId,
      required this.message,
      required this.date,
      required this.senderFirstName,
      required this.senderLastName,
      this.responderFirstName,
      this.responderLastName,
      required this.read});

  factory Message.fromJson(Map<String?, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String?, dynamic> toJson() => _$MessageToJson(this);

  final int id;
  final String senderId;
  final String? responderId;
  final int groupId;
  final String senderFirstName;
  final String senderLastName;
  final String? responderFirstName;
  final String? responderLastName;
  final String message;
  final String date;
  final String read;
}
