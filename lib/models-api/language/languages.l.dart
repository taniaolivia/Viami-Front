part of 'languages.dart';

Languages _$LanguagesFromJson(Map<String?, dynamic> json) => Languages(
      languages: (json['languages'] as List<dynamic>)
          .map((e) => Language.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$LanguagesToJson(Languages instance) =>
    <String?, dynamic>{'languages': instance.languages};
