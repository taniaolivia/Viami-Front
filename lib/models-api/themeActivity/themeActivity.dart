import 'package:json_annotation/json_annotation.dart';

part 'themeActivity.t.dart';

@JsonSerializable()
class ThemeActivity {
  ThemeActivity({
    required this.id,
    required this.themeId,
    required this.activityId,
    required this.name,
    required this.imageName,
    required this.location,
    required this.isRecommended,
    this.nbParticipant,
    required this.theme,
    required this.icon,
  });

  factory ThemeActivity.fromJson(Map<String?, dynamic> json) =>
      _$ThemeActivityFromJson(json);
  Map<String?, dynamic> toJson() => _$ThemeActivityToJson(this);

  final int id;
  final int? themeId;
  final int? activityId;
  final String name;
  final String imageName;
  final String location;
  final int isRecommended;
  final int? nbParticipant;
  final String theme;
  final String icon;
}
