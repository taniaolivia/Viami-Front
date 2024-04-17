part of 'auth.dart';

User _$UserFromJson(Map<String?, dynamic> json) =>
    User(email: json['email'], password: json['password']);

Map<String?, dynamic> _$UserToJson(User instance) =>
    <String?, dynamic>{'email': instance.email, 'password': instance.password};

Auth _$AuthFromJson(Map<String?, dynamic> json) => Auth(
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    token: json['token'],
    message: json["message"]);

Map<String?, dynamic> _$AuthToJson(Auth instance) => <String?, dynamic>{
      "user": instance.user,
      "token": instance.token,
      "message": instance.message
    };
