part of 'travelsActivities.dart';

TravelActivity _$TravelActivityFromJson(Map<String?, dynamic> json) =>
    TravelActivity(
        id: json['id'],
        idActivity: json["idActivity"],
        idTravel: json['idTravel'],
        name: json["name"],
        travelDescription: json["travelDescription"],
        location: json['location'],
        nbPepInt: json['nbPepInt'],
        activityName: json['activityName'],
        imageName: json['imageName'],
        activityLocation: json['activityLocation']);

Map<String?, dynamic> _$TravelActivityToJson(TravelActivity instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'idActivity': instance.idActivity,
      'idTravel': instance.idTravel,
      'name': instance.name,
      'travelDescription': instance.travelDescription,
      'location': instance.location,
      'nbPepInt': instance.nbPepInt,
      'activityName': instance.activityName,
      'imageName': instance.imageName,
      'activityLocation': instance.activityLocation
    };

TravelsActivities _$TravelsActivitiesFromJson(Map<String?, dynamic> json) =>
    TravelsActivities(
      travelActivities: (json['travelActivities'] as List<dynamic>)
          .map((e) => TravelActivity.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$TravelsActivitiesToJson(TravelsActivities instance) =>
    <String?, dynamic>{'travelActivities': instance.travelActivities};
