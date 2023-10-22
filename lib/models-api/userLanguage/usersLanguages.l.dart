part of 'usersLanguages.dart';

UserLanguage _$UserLanguageFromJson(Map<String?, dynamic> json) => UserLanguage(
      id: json['id'],
      userId: json["userId"],
      languageId: json['languageId'],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json['email'],
      password: json['password'],
      description: json['description'],
      location: json['location'],
      phoneNumber: json['phoneNumber'],
      birthday: json["birthday"],
      age: json['age'],
      sex: json['sex'],
      lastConnection: json['lastConnection'],
      connected: json["connected"],
      language: json['language'],
    );

Map<String?, dynamic> _$UserLanguageToJson(UserLanguage instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'languageId': instance.languageId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'description': instance.description,
      'location': instance.location,
      'phoneNumber': instance.phoneNumber,
      'birthday': instance.birthday,
      'age': instance.age,
      'sex': instance.sex,
      'lastConnection': instance.lastConnection,
      'connected': instance.connected,
      'language': instance.language
    };

UsersLanguages _$UsersLanguagesFromJson(Map<String?, dynamic> json) =>
    UsersLanguages(
      userLanguages: (json['userLanguages'] as List<dynamic>)
          .map((e) => UserLanguage.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$UsersLanguagesToJson(UsersLanguages instance) =>
    <String?, dynamic>{'userLanguages': instance.userLanguages};
