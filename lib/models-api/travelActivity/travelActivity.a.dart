part of 'travelActivity.dart';

TravelActivity _$TravelActivityFromJson(Map<String?, dynamic> json) =>
    TravelActivity(
        id: json['id'],
        idTravel: json['idActivity'],
        idImage: json["idTravel"]);

Map<String?, dynamic> _$TravelActivityToJson(TravelActivity instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'idActivity': instance.idTravel,
      'idTravel': instance.idImage,
    };
