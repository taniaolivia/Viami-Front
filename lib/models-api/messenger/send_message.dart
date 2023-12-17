import 'package:json_annotation/json_annotation.dart';

part 'send_message.s.dart';

@JsonSerializable()
class Sendmessage {
  int groupId;
  String message;
  String? senderId;
  String? responderId;

  Sendmessage({
    required this.groupId,
    required this.message,
    required this.senderId,
    required this.responderId,
  });

  factory Sendmessage.fromJson(Map<String?, dynamic> json) =>
      _$SendmessageFromJson(json);
  Map<String?, dynamic> toJson() => _$SendmessageToJson(this);
}
