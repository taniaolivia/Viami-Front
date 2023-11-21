part of 'usersDateLocation.dart';

UsersDateLocation _$UsersDateLocationFromJson(Map<String?, dynamic> json) =>
    UsersDateLocation(
      nbParticipant: json['nbParticipant'],
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => UserDateLocation.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$UsersDateLocationToJson(UsersDateLocation instance) =>
    <String?, dynamic>{
      'nbParticipant': instance.nbParticipant,
      'users': instance.users
    };
