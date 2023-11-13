part of 'activitiesImages.dart';

ActivityImage _$ActivityImageFromJson(Map<String?, dynamic> json) =>
    ActivityImage(
      id: json['id'],
      idImage: json["idImage"],
      idActivity: json['idActivity'],
      name: json["name"],
      description: json["description"],
      location: json['location'],
      isRecommended: json['isRecommended'],
      nbParticipant: json['nbParticipant'],
      image: json['image'],
      imageName: json['imageName'],
    );

Map<String?, dynamic> _$ActivityImageToJson(ActivityImage instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'idImage': instance.idImage,
      'idActivity': instance.idActivity,
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'isRecommended': instance.isRecommended,
      'nbParticipant': instance.nbParticipant,
      'image': instance.image,
      'imageName': instance.imageName,
    };

ActivitiesImages _$ActivitiesImagesFromJson(Map<String?, dynamic> json) =>
    ActivitiesImages(
      activityImages: (json['activityImages'] as List<dynamic>)
          .map((e) => ActivityImage.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$ActivitiesImagesToJson(ActivitiesImages instance) =>
    <String?, dynamic>{'activityImages': instance.activityImages};
