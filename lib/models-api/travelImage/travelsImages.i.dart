part of 'travelsImages.dart';

TravelImage _$TravelImageFromJson(Map<String?, dynamic> json) => TravelImage(
      id: json['id'],
      idImage: json["idImage"],
      idTravel: json['idTravel'],
      name: json["name"],
      travelDescription: json["travelDescription"],
      location: json['location'],
      nbPepInt: json['nbPepInt'],
      imageName: json['imageName'],
    );

Map<String?, dynamic> _$TravelImageToJson(TravelImage instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'idImage': instance.idImage,
      'idTravel': instance.idTravel,
      'name': instance.name,
      'travelDescription': instance.travelDescription,
      'location': instance.location,
      'nbPepInt': instance.nbPepInt,
      'imageName': instance.imageName,
    };

TravelsImages _$TravelsImagesFromJson(Map<String?, dynamic> json) =>
    TravelsImages(
      travelImages: (json['travelImages'] as List<dynamic>)
          .map((e) => TravelImage.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$TravelsImagesToJson(TravelsImages instance) =>
    <String?, dynamic>{'travelImages': instance.travelImages};
