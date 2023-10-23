import 'package:json_annotation/json_annotation.dart';

part 'user.u.dart';

@JsonSerializable()
class User {
  User(
      {this.id,
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
      this.message,
      this.connected});

  factory User.fromJson(Map<String?, dynamic> json) => _$UserFromJson(json);
  Map<String?, dynamic> toJson() => _$UserToJson(this);

  final String? id;
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
}
