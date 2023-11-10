import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/themeTravel/themeTravel.dart';

part 'themesTravels.t.dart';

@JsonSerializable()
class ThemesTravels {
  ThemesTravels({required this.travels});

  factory ThemesTravels.fromJson(Map<String?, dynamic> json) =>
      _$ThemesTravelsFromJson(json);
  Map<String?, dynamic> toJson() => _$ThemesTravelsToJson(this);

  final List<ThemeTravel> travels;
}
