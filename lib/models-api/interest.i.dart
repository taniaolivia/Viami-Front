part of 'interest.dart';

Interest _$InterestFromJson(Map<String?, dynamic> json) => Interest(
      id: json['id'],
      interest: json['interest'],
      message: json["message"],
    );

Map<String?, dynamic> _$InterestToJson(Interest instance) => <String?, dynamic>{
      'id': instance.id,
      'interest': instance.interest,
    };
