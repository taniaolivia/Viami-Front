import 'package:json_annotation/json_annotation.dart';
part 'message.m.dart';

@JsonSerializable()
class Message {
  Message({
    this.id,
    required this.message,
    this.senderId,
    this.responderId,
    this.date,
    this.read,
  });

  factory Message.fromJson(Map<String?, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String?, dynamic> toJson() => _$MessageToJson(this);

  final int? id;
  final String message;
  final String? senderId;
  final String? responderId;
  final String? date;
  final String? read;
}
