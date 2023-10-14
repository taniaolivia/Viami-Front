import 'dart:convert';
import 'package:http/http.dart' as http;
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
      this.interest,
      required this.location,
      this.description,
      required this.phoneNumber,
      required this.age,
      required this.sex,
      required this.lastConnection,
      required this.connected});

  factory User.fromJson(Map<String?, dynamic> json) => _$UserFromJson(json);
  Map<String?, dynamic> toJson() => _$UserToJson(this);

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? interest;
  final String? location;
  final String? description;
  final String phoneNumber;
  final num age;
  final String sex;
  final String? lastConnection;
  final bool? connected;
}