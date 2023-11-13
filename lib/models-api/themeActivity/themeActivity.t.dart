part of 'themeActivity.dart';

ThemeActivity _$ThemeActivityFromJson(Map<String?, dynamic> json) =>
    ThemeActivity(
        id: json['id'],
        themeId: json['themeId'],
        activityId: json['activityId'],
        icon: json['icon'],
        theme: json['theme'],
        name: json['name'],
        location: json['location'],
        imageName: json['imageName'],
        nbParticipant: json['nbParticipant'],
        isRecommended: json['isRecommended']);

Map<String?, dynamic> _$ThemeActivityToJson(ThemeActivity instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'themeId': instance.themeId,
      'activityId': instance.activityId,
      'icon': instance.icon,
      'theme': instance.theme,
      'name': instance.name,
      'location': instance.location,
      'imageName': instance.imageName,
      'nbParticipant': instance.nbParticipant,
      'isRecommended': instance.isRecommended
    };
