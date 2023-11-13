import 'package:json_annotation/json_annotation.dart';

part 'activitiesImages.a.dart';

@JsonSerializable()
class ActivityImage {
  ActivityImage({
    required this.id,
    required this.idImage,
    required this.idActivity,
    required this.name,
    this.description,
    required this.location,
    this.nbParticipant,
    required this.isRecommended,
    required this.imageName,
    required this.image,
  });

  factory ActivityImage.fromJson(Map<String?, dynamic> json) =>
      _$ActivityImageFromJson(json);
  Map<String?, dynamic> toJson() => _$ActivityImageToJson(this);

  final int id;
  final int idImage;
  final int idActivity;
  final String name;
  final String? description;
  final String location;
  final int? nbParticipant;
  final int isRecommended;
  final String imageName;
  final String image;
}

class ActivitiesImages {
  ActivitiesImages({required this.activityImages});

  factory ActivitiesImages.fromJson(Map<String?, dynamic> json) =>
      _$ActivitiesImagesFromJson(json);
  Map<String?, dynamic> toJson() => _$ActivitiesImagesToJson(this);

  final List<ActivityImage> activityImages;
}
