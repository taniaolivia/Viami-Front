import 'package:json_annotation/json_annotation.dart';

part 'usersLanguages.l.dart';

@JsonSerializable()
class UserLanguage {
  UserLanguage(
      {required this.id,
      required this.userId,
      required this.languageId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.location,
      this.description,
      required this.phoneNumber,
      required this.birthday,
      required this.age,
      required this.sex,
      required this.lastConnection,
      required this.connected,
      required this.language,
      this.profileImage,
      required this.imageName});

  factory UserLanguage.fromJson(Map<String?, dynamic> json) =>
      _$UserLanguageFromJson(json);
  Map<String?, dynamic> toJson() => _$UserLanguageToJson(this);

  final int id;
  final String userId;
  final int languageId;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String location;
  final String? description;
  final String phoneNumber;
  final String birthday;
  final num age;
  final String sex;
  final String lastConnection;
  final String connected;
  final String language;
  final String? profileImage;
  final String imageName;
}

class UsersLanguages {
  UsersLanguages({required this.userLanguages});

  factory UsersLanguages.fromJson(Map<String?, dynamic> json) =>
      _$UsersLanguagesFromJson(json);
  Map<String?, dynamic> toJson() => _$UsersLanguagesToJson(this);

  final List<UserLanguage> userLanguages;
}
