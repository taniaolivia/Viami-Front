part of 'userImage.dart';

UserImage _$UserImageFromJson(Map<String?, dynamic> json) =>
    UserImage(id: json['id'], imageId: json['imageId'], userId: json["userId"]);

Map<String?, dynamic> _$UserImageToJson(UserImage instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'imageId': instance.imageId,
      'userId': instance.userId,
    };
