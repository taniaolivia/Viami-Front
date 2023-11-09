import 'package:json_annotation/json_annotation.dart';

part 'travelsImages.i.dart';

@JsonSerializable()
class TravelImage {
  TravelImage({
    required this.id,
    required this.idImage,
    required this.idTravel,
    required this.name,
    required this.travelDescription,
    required this.location,
    this.nbPepInt,
    required this.imageName,
  });

  factory TravelImage.fromJson(Map<String?, dynamic> json) =>
      _$TravelImageFromJson(json);
  Map<String?, dynamic> toJson() => _$TravelImageToJson(this);

  final int id;
  final int idImage;
  final int idTravel;
  final String name;
  final String travelDescription;
  final String location;
  final int? nbPepInt;
  final String imageName;
}

class TravelsImages {
  TravelsImages({required this.travelImages});

  factory TravelsImages.fromJson(Map<String?, dynamic> json) =>
      _$TravelsImagesFromJson(json);
  Map<String?, dynamic> toJson() => _$TravelsImagesToJson(this);

  final List<TravelImage> travelImages;
}
