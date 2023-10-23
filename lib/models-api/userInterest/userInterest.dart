import 'package:json_annotation/json_annotation.dart';

part 'userInterest.u.dart';

@JsonSerializable()
class UserInterest {
  UserInterest({this.id, required this.interestId, this.userId});

  factory UserInterest.fromJson(Map<String?, dynamic> json) =>
      _$UserInterestFromJson(json);
  Map<String?, dynamic> toJson() => _$UserInterestToJson(this);

  final String? id;
  final String interestId;
  final String? userId;
}
