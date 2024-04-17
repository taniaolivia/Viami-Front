part of 'travelImage.dart';

TravelImage _$TravelImageFromJson(Map<String?, dynamic> json) => TravelImage(
    id: json['id'], idTravel: json['idTravel'], idImage: json["idImage"]);

Map<String?, dynamic> _$TravelImageToJson(TravelImage instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'idTravel': instance.idTravel,
      'idImage': instance.idImage,
    };
