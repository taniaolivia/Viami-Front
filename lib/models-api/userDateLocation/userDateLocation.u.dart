part of 'userDateLocation.dart';

UserDateLocation _$UserDateLocationFromJson(Map<String?, dynamic> json) =>
    UserDateLocation(
        id: json['id'],
        dateLocationId: json['dateLocationId'],
        userId: json['userId'],
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
        connected: json["connected"],
        profileImage: json["profileImage"],
        verifyEmailToken: json["verifyEmailToken"],
        emailVerified: json["emailVerified"],
        date: json['date'],
        nbParticipant: json['nbParticipant']);

Map<String?, dynamic> _$UserDateLocationToJson(UserDateLocation instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'dateLocationId': instance.dateLocationId,
      'userId': instance.userId,
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
      'date': instance.date,
      'nbParticipant': instance.nbParticipant
    };
