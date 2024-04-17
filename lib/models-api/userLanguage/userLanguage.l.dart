part of 'userLanguage.dart';

UserLanguage _$UserLanguageFromJson(Map<String?, dynamic> json) => UserLanguage(
    id: json['id'], languageId: json['languageId'], userId: json["userId"]);

Map<String?, dynamic> _$UserLanguageToJson(UserLanguage instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'languageId': instance.languageId,
      'userId': instance.userId,
    };
