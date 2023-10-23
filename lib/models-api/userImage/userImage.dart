import 'package:json_annotation/json_annotation.dart';

part 'userImage.i.dart';

@JsonSerializable()
class UserImage {
  UserImage({this.id, required this.imageId, this.userId});

  factory UserImage.fromJson(Map<String?, dynamic> json) =>
      _$UserImageFromJson(json);
  Map<String?, dynamic> toJson() => _$UserImageToJson(this);

  final String? id;
  final String imageId;
  final String? userId;
}
