import 'package:json_annotation/json_annotation.dart';

part 'user.u.dart';

@JsonSerializable()
class User {
  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.interest,
      required this.description,
      required this.location,
      required this.phoneNumber,
      required this.age,
      required this.sex,
      required this.lastConnection,
      required this.message});

  factory User.fromJson(Map<String?, dynamic> json) => _$UserFromJson(json);
  Map<String?, dynamic> toJson() => _$UserToJson(this);

  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? interest;
  final String? description;
  final String location;
  final String phoneNumber;
  final num age;
  final String sex;
  final String? lastConnection;
  final String? message;
}
