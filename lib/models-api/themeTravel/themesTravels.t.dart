part of 'themesTravels.dart';

ThemesTravels _$ThemesTravelsFromJson(Map<String?, dynamic> json) =>
    ThemesTravels(
      travels: (json['travels'] as List<dynamic>)
          .map((e) => ThemeTravel.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$ThemesTravelsToJson(ThemesTravels instance) =>
    <String?, dynamic>{'travels': instance.travels};
