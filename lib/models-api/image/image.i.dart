part of 'image.dart';

Image _$ImageFromJson(Map<String?, dynamic> json) => Image(
      id: json['id'],
      image: json['image'],
    );

Map<String?, dynamic> _$ImageToJson(Image instance) => <String?, dynamic>{
      'id': instance.id,
      'image': instance.image,
    };
