part of 'userInterest.dart';

UserInterest _$UserInterestFromJson(Map<String?, dynamic> json) => UserInterest(
    id: json['id'], interestId: json['interestId'], userId: json["userId"]);

Map<String?, dynamic> _$UserInterestToJson(UserInterest instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'interestId': instance.interestId,
      'userId': instance.userId,
    };
