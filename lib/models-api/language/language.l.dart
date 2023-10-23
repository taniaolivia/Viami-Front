part of 'language.dart';

Language _$LanguageFromJson(Map<String?, dynamic> json) => Language(
      id: json['id'],
      language: json['language'],
      imageName: json['imageName'],
    );

Map<String?, dynamic> _$LanguageToJson(Language instance) => <String?, dynamic>{
      'id': instance.id,
      'language': instance.language,
      'imageName': instance.imageName,
    };
