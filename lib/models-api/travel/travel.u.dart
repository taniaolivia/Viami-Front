part of 'travel.dart';

Travel _$TravelFromJson(Map<String?, dynamic> json) => Travel(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    location: json['location'],
    nbPepInt: json['nbPepInt'].toString(),
    isRecommended: json["isRecommended"]);

Map<String?, dynamic> _$TravelToJson(Travel instance) => <String?, dynamic>{
      'id': instance.id,
      'firstName': instance.name,
      'description': instance.description,
      'location': instance.location,
      'nbPepInt': (instance.nbPepInt).toString(),
      'isRecommended': instance.isRecommended
    };
