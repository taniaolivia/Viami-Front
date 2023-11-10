part of 'travel.dart';

Travel _$TravelFromJson(Map<String?, dynamic> json) => Travel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      image: json['image'],
      nbPepInt: json['nbPepInt'],
      isRecommended: json['isRecommended'],
    );

Map<String?, dynamic> _$TravelToJson(Travel instance) => <String?, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'image': instance.image,
      'nbPepInt': instance.nbPepInt,
      'isRecommended': instance.isRecommended
    };
