part of 'usersImages.dart';

UserImage _$UserImageFromJson(Map<String?, dynamic> json) => UserImage(
      id: json['id'],
      userId: json["userId"],
      imageId: json['imageId'],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json['email'],
      password: json['password'],
      description: json['description'],
      location: json['location'],
      phoneNumber: json['phoneNumber'],
      birthday: json["birthday"],
      age: json['age'],
      sex: json['sex'],
      lastConnection: json['lastConnection'],
      connected: json["connected"],
      profileImage: json["profileImage"],
      verifyEmailToken: json["verifyEmailToken"],
      emailVerified: json["emailVerified"],
      image: json['image'],
    );

Map<String?, dynamic> _$UserImageToJson(UserImage instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'imageId': instance.imageId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'description': instance.description,
      'location': instance.location,
      'phoneNumber': instance.phoneNumber,
      'birthday': instance.birthday,
      'age': instance.age,
      'sex': instance.sex,
      'lastConnection': instance.lastConnection,
      'connected': instance.connected,
      'profileImage': instance.profileImage,
      'verifyEmailToken': instance.verifyEmailToken,
      'emailVerified': instance.emailVerified,
      'image': instance.image
    };

UsersImages _$UsersImagesFromJson(Map<String?, dynamic> json) => UsersImages(
      userImages: (json['userImages'] as List<dynamic>)
          .map((e) => UserImage.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$UsersImagesToJson(UsersImages instance) =>
    <String?, dynamic>{'userImages': instance.userImages};
