import 'package:json_annotation/json_annotation.dart';

part 'theme.t.dart';

@JsonSerializable()
class Theme {
  Theme({required this.id, required this.theme, required this.icon});

  factory Theme.fromJson(Map<String?, dynamic> json) => _$ThemeFromJson(json);
  Map<String?, dynamic> toJson() => _$ThemeToJson(this);

  final int id;
  final String theme;
  final String icon;
}
