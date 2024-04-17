import 'package:json_annotation/json_annotation.dart';

part 'image.i.dart';

@JsonSerializable()
class Image {
  Image({this.id, required this.image});

  factory Image.fromJson(Map<String?, dynamic> json) => _$ImageFromJson(json);
  Map<String?, dynamic> toJson() => _$ImageToJson(this);

  final int? id;
  final String image;
}
