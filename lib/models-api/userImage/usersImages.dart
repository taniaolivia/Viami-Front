import 'package:json_annotation/json_annotation.dart';

part 'usersImages.i.dart';

@JsonSerializable()
class UserImage {
  UserImage(
      {required this.id,
      required this.userId,
      required this.imageId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.location,
      this.description,
      required this.phoneNumber,
      required this.birthday,
      required this.age,
      required this.sex,
      required this.lastConnection,
      required this.connected,
      this.profileImage,
      this.verifyEmailToken,
      this.emailVerified,
      required this.image});

  factory UserImage.fromJson(Map<String?, dynamic> json) =>
      _$UserImageFromJson(json);
  Map<String?, dynamic> toJson() => _$UserImageToJson(this);

  final int id;
  final String userId;
  final int imageId;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String location;
  final String? description;
  final String phoneNumber;
  final String birthday;
  final num age;
  final String sex;
  final String lastConnection;
  final String connected;
  final String? profileImage;
  final String? verifyEmailToken;
  final String? emailVerified;
  final String image;
}

class UsersImages {
  UsersImages({required this.userImages});

  factory UsersImages.fromJson(Map<String?, dynamic> json) =>
      _$UsersImagesFromJson(json);
  Map<String?, dynamic> toJson() => _$UsersImagesToJson(this);

  final List<UserImage> userImages;
}
