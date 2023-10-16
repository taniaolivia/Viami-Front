import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/user.dart';

part 'users.u.dart';

@JsonSerializable()
class Users {
  Users({required this.users});

  factory Users.fromJson(Map<String?, dynamic> json) => _$UsersFromJson(json);
  Map<String?, dynamic> toJson() => _$UsersToJson(this);

  final List<User> users;
}
