part of 'travels.dart';

Travels _$TravelsFromJson(Map<String?, dynamic> json) => Travels(
      travels: (json['travels'] as List<dynamic>)
          .map((e) => Travel.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$TravelsToJson(Travels instance) =>
    <String?, dynamic>{'travels': instance.travels};
