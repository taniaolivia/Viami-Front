part of 'activity.dart';

Activity _$ActivityFromJson(Map<String?, dynamic> json) => Activity(
    id: json['id'],
    name: json['name'],
    imageName: json['imageName'],
    location: json['location'],
    isRecommended: json['isRecommended'],
    nbParticipant: json['nbParticipant'],
    description: json['description'],
    note: json['note'],
    url: json['url'],
    telephone: json['telephone'],
    address: json['address'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    schedule: json['schedule'],
    language: json['language'],
    accessibility: json['accessibility']);

Map<String?, dynamic> _$ActivityToJson(Activity instance) => <String?, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageName': instance.imageName,
      'location': instance.location,
      'isRecommended': instance.isRecommended,
      'nbParticipant': instance.nbParticipant,
      'description': instance.description,
      'note': instance.note,
      'url': instance.url,
      'telephone': instance.telephone,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'schedule': instance.schedule,
      'language': instance.language,
      'accessibility': instance.accessibility
    };
