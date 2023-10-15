part of 'user.dart';

User _$UserFromJson(Map<String?, dynamic> json) => User(
    firstName: json['firstName'] as String? ?? '',
    lastName: json['lastName'] as String? ?? '',
    email: json['email'] as String? ?? '',
    password: json['password'] as String? ?? '',
    interest: json['interest'] as String? ?? '',
    description: json['description'] as String? ?? '',
    location: json['location'] as String? ?? '',
    phoneNumber: json['phoneNumber'] as String? ?? '',
    age: json['age'] as num? ?? 0,
    sex: json['sex'] as String? ?? '',
    lastConnection: json['lastConnection'] as String? ?? '');

Map<String?, dynamic> _$UserToJson(User instance) => <String?, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'interest': instance.interest,
      'description': instance.description,
      'location': instance.location,
      'phoneNumber': instance.phoneNumber,
      'age': instance.age,
      'sex': instance.sex,
      'lastConnection': instance.lastConnection
    };
