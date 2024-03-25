part of 'images.dart';

Images _$ImagesFromJson(Map<String?, dynamic> json) => Images(
      images: (json['images'] as List<dynamic>)
          .map((e) => Image.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$ImagesToJson(Images instance) =>
    <String?, dynamic>{'images': instance.images};
