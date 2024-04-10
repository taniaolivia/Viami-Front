import 'package:json_annotation/json_annotation.dart';

part 'messageUser.m.dart';

@JsonSerializable()
class MessageUser {
  int groupId;
  String message;
  String? senderId;
  String? responderId;

  MessageUser({
    required this.groupId,
    required this.message,
    required this.senderId,
    required this.responderId,
  });

  factory MessageUser.fromJson(Map<String?, dynamic> json) =>
      _$MessageUserFromJson(json);
  Map<String?, dynamic> toJson() => _$MessageUserToJson(this);
}
