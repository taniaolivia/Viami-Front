import 'package:json_annotation/json_annotation.dart';

part 'message.m.dart';

@JsonSerializable()
class Message {
  Message(
      {required this.id,
      required this.senderId,
      required this.responderId,
      required this.message,
      required this.date,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      this.description,
      required this.location,
      required this.phoneNumber,
      required this.birthday,
      this.age,
      required this.sex,
      this.lastConnection,
      this.connected,
      this.profileImage,
      this.verifyEmailToken,
      this.emailVerified,
      required this.plan});

  factory Message.fromJson(Map<String?, dynamic> json) => _$MessageFromJson(json);
  Map<String?, dynamic> toJson() => _$MessageToJson(this);

  final String? id;
  final String senderId;
  final String responderId;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? description;
  final String location;
  final String phoneNumber;
  final String birthday;
  final num? age;
  final String sex;
  final String? lastConnection;
  final String? message;
  final String? connected;
  final String? profileImage;
  final String? verifyEmailToken;
  final String? emailVerified;
  final String plan;
  final String date;
}
