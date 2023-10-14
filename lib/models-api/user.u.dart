part of 'user.dart';

User _$UserFromJson(Map<String?, dynamic> json) => User(
    id: json['id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    password: json['password'],
    interest: json['interest'],
    location: json['location'],
    description: json['description'],
    phoneNumber: json['phoneNumber'],
    age: json['age'],
    sex: json['sex'],
    lastConnection: json['lastConnection'],
    connected: json['connected']);

Map<String?, dynamic> _$UserToJson(User instance) => <String?, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'interest': instance.interest,
      'location': instance.location,
      'description': instance.description,
      'phoneNumber': instance.phoneNumber,
      'age': instance.age,
      'sex': instance.sex,
      'lastConnection': instance.lastConnection,
      'connected': instance.connected
    };
