part of 'themeActivities.dart';

ThemeActivities _$ThemeActivitiesFromJson(Map<String?, dynamic> json) =>
    ThemeActivities(
      activities: (json['activities'] as List<dynamic>)
          .map((e) => ThemeActivity.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$ThemeActivitiesToJson(ThemeActivities instance) =>
    <String?, dynamic>{'activities': instance.activities};
