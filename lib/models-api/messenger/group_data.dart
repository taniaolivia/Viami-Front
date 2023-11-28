import 'package:json_annotation/json_annotation.dart';

part 'group_data.g.dart';

@JsonSerializable()
class LastMessage {
  final int id;
  final String message;
  final String senderId;
  final int groupId;
  final String responderId;
  final String date;
  final String read;
  final String senderFirstName;
  final String senderLastName;
  final String responderFirstName;
  final String responderLastName;

  LastMessage({
    required this.id,
    required this.message,
    required this.senderId,
    required this.groupId,
    required this.responderId,
    required this.date,
    required this.read,
    required this.senderFirstName,
    required this.senderLastName,
    required this.responderFirstName,
    required this.responderLastName,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) =>
      _$LastMessageFromJson(json);

  Map<String, dynamic> toJson() => _$LastMessageToJson(this);
}

@JsonSerializable()
class UserData {
  final String id;
  final String firstName;
  final String lastName;

  UserData({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class GroupData {
  final int groupId;
  final LastMessage lastMessage;
  final List<UserData> users;

  GroupData({
    required this.groupId,
    required this.lastMessage,
    required this.users,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) =>
      _$GroupDataFromJson(json);

  Map<String, dynamic> toJson() => _$GroupDataToJson(this);
}
