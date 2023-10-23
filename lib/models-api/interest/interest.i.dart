part of 'interest.dart';

Interest _$InterestFromJson(Map<String?, dynamic> json) => Interest(
      id: json['id'],
      interest: json['interest'],
      imageName: json['imageName'],
    );

Map<String?, dynamic> _$InterestToJson(Interest instance) => <String?, dynamic>{
      'id': instance.id,
      'interest': instance.interest,
      'imageName': instance.imageName,
    };
