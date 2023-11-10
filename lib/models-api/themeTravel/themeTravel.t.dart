part of 'themeTravel.dart';

ThemeTravel _$ThemeTravelFromJson(Map<String?, dynamic> json) => ThemeTravel(
    id: json['id'],
    themeId: json['themeId'],
    travelId: json['travelId'],
    theme: json['theme'],
    name: json['name'],
    description: json['description'],
    location: json['location'],
    image: json['image'],
    nbPepInt: json['nbPepInt'],
    isRecommended: json['isRecommended']);

Map<String?, dynamic> _$ThemeTravelToJson(ThemeTravel instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'themeId': instance.themeId,
      'travelId': instance.travelId,
      'theme': instance.theme,
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'image': instance.image,
      'nbPepInt': instance.nbPepInt
    };
