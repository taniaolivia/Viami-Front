part of 'theme.dart';

Theme _$ThemeFromJson(Map<String?, dynamic> json) => Theme(
      id: json['id'],
      theme: json['theme'],
    );

Map<String?, dynamic> _$ThemeToJson(Theme instance) => <String?, dynamic>{
      'id': instance.id,
      'theme': instance.theme,
    };
