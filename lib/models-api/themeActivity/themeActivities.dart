import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/themeActivity/themeActivity.dart';

part 'themeActivities.t.dart';

@JsonSerializable()
class ThemeActivities {
  ThemeActivities({required this.activities});

  factory ThemeActivities.fromJson(Map<String?, dynamic> json) =>
      _$ThemeActivitiesFromJson(json);
  Map<String?, dynamic> toJson() => _$ThemeActivitiesToJson(this);

  final List<ThemeActivity> activities;
}
