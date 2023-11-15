import 'package:json_annotation/json_annotation.dart';

part 'userDateLocation.u.dart';

@JsonSerializable()
class UserDateLocation {
  UserDateLocation(
      {required this.id,
      required this.dateLocationId,
      required this.userId,
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
      required this.date,
      required this.nbParticipant,
      required this.plan});

  factory UserDateLocation.fromJson(Map<String?, dynamic> json) =>
      _$UserDateLocationFromJson(json);
  Map<String?, dynamic> toJson() => _$UserDateLocationToJson(this);

  final int id;
  final int dateLocationId;
  final String userId;
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
  final String? connected;
  final String? profileImage;
  final String? verifyEmailToken;
  final String? emailVerified;
  final String date;
  final int nbParticipant;
  final String plan;
}
