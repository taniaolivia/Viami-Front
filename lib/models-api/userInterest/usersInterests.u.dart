part of 'usersInterests.dart';

UserInterest _$UserInterestFromJson(Map<String?, dynamic> json) => UserInterest(
    id: json['id'],
    userId: json["userId"],
    interestId: json['interestId'],
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
    interest: json['interest'],
    imageName: json['imageName']);

Map<String?, dynamic> _$UserInterestToJson(UserInterest instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'interestId': instance.interestId,
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
      'interest': instance.interest,
      'imageName': instance.imageName
    };

UsersInterests _$UsersInterestsFromJson(Map<String?, dynamic> json) =>
    UsersInterests(
      userInterests: (json['userInterests'] as List<dynamic>)
          .map((e) => UserInterest.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$UsersInterestsToJson(UsersInterests instance) =>
    <String?, dynamic>{'userInterests': instance.userInterests};
