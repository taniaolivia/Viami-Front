part of 'travelActivity.dart';

TravelActivity _$TravelActivityFromJson(Map<String?, dynamic> json) =>
    TravelActivity(
        id: json['id'],
        idActivity: json['idActivity'],
        idTravel: json["idTravel"]);

Map<String?, dynamic> _$TravelActivityToJson(TravelActivity instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'idTravel': instance.idTravel,
      'idActivity': instance.idActivity,
    };
