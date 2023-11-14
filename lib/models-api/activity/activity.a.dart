part of 'activity.dart';

Activity _$ActivityFromJson(Map<String?, dynamic> json) => Activity(
    id: json['id'],
    name: json['name'],
    imageName: json['imageName'],
    location: json['location'],
    isRecommended: json['isRecommended'],
    nbParticipant: json['nbParticipant'],
    description: json['description'],
    note: json['note']);

Map<String?, dynamic> _$ActivityToJson(Activity instance) => <String?, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageName': instance.imageName,
      'location': instance.location,
      'isRecommended': instance.isRecommended,
      'nbParticipant': instance.nbParticipant,
      'description': instance.description,
      'note': instance.note
    };
