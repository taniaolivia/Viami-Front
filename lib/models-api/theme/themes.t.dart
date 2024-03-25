part of 'themes.dart';

Themes _$ThemesFromJson(Map<String?, dynamic> json) => Themes(
      themes: (json['themes'] as List<dynamic>)
          .map((e) => Theme.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$ThemesToJson(Themes instance) =>
    <String?, dynamic>{'themes': instance.themes};
