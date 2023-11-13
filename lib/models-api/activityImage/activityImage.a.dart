part of 'activityImage.dart';

ActivityImage _$ActivityImageFromJson(Map<String?, dynamic> json) =>
    ActivityImage(
        id: json['id'],
        idActivity: json['idActivity'],
        idImage: json["idImage"]);

Map<String?, dynamic> _$ActivityImageToJson(ActivityImage instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'idActivity': instance.idActivity,
      'idImage': instance.idImage,
    };
