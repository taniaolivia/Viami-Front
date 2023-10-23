import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/image/image.dart';

part 'images.i.dart';

@JsonSerializable()
class Images {
  Images({required this.images});

  factory Images.fromJson(Map<String?, dynamic> json) => _$ImagesFromJson(json);
  Map<String?, dynamic> toJson() => _$ImagesToJson(this);

  final List<Image> images;
}
