import 'package:json_annotation/json_annotation.dart';

part 'auth.a.dart';

@JsonSerializable()
class User {
  User({required this.email, required this.password});

  factory User.fromJson(Map<String?, dynamic> json) => _$UserFromJson(json);

  Map<String?, dynamic> toJson() => _$UserToJson(this);

  final String email;
  final String password;
}

class Auth {
  Auth({required this.user, this.token, this.message});

  factory Auth.fromJson(Map<String?, dynamic> json) => _$AuthFromJson(json);

  Map<String?, dynamic> toJson() => _$AuthToJson(this);

  final User user;
  final String? token;
  final String? message;
}
