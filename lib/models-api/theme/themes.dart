import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/theme/theme.dart';

part 'themes.t.dart';

@JsonSerializable()
class Themes {
  Themes({required this.themes});

  factory Themes.fromJson(Map<String?, dynamic> json) => _$ThemesFromJson(json);
  Map<String?, dynamic> toJson() => _$ThemesToJson(this);

  final List<Theme> themes;
}
