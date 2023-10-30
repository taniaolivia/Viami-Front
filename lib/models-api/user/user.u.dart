part of 'user.dart';

User _$UserFromJson(Map<String?, dynamic> json) => User(
    id: json['id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    password: json['password'],
    description: json['description'],
    location: json['location'],
    phoneNumber: json['phoneNumber'],
    birthday: json["birthday"],
    age: json['age'],
    sex: json['sex'],
    lastConnection: json['lastConnection'],
    message: json["message"],
    connected: json["connected"],
    profileImage: json["profileImage"],
    verifyEmailToken: json["verifyEmailToken"],
    emailVerified: json["emailVerified"]);

Map<String?, dynamic> _$UserToJson(User instance) => <String?, dynamic>{
      'id': instance.id,
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
      'emailVerified': instance.emailVerified
    };
