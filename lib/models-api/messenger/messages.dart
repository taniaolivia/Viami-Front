import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/messenger/message.dart';

part 'messages.m.dart';

@JsonSerializable()
class Messages {
  Messages({required this.messages});

  factory Messages.fromJson(Map<String?, dynamic> json) => _$MessagesFromJson(json);
  Map<String?, dynamic> toJson() => _$MessagesToJson(this);

  final List<Message> messages;
}
