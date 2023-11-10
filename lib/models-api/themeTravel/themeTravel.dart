import 'package:json_annotation/json_annotation.dart';

part 'themeTravel.t.dart';

@JsonSerializable()
class ThemeTravel {
  ThemeTravel(
      {required this.id,
      required this.themeId,
      required this.travelId,
      required this.name,
      this.description,
      required this.location,
      required this.image,
      this.nbPepInt,
      required this.isRecommended,
      required this.theme});

  factory ThemeTravel.fromJson(Map<String?, dynamic> json) =>
      _$ThemeTravelFromJson(json);
  Map<String?, dynamic> toJson() => _$ThemeTravelToJson(this);

  final int id;
  final int? themeId;
  final int? travelId;
  final String theme;
  final String name;
  final String? description;
  final String location;
  final String image;
  final int? nbPepInt;
  final int isRecommended;
}
