import 'package:json_annotation/json_annotation.dart';

part 'usersInterests.u.dart';

@JsonSerializable()
class UserInterest {
  UserInterest(
      {required this.id,
      required this.userId,
      required this.interestId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.location,
      this.description,
      required this.phoneNumber,
      required this.birthday,
      required this.age,
      required this.sex,
      required this.lastConnection,
      required this.connected,
      required this.interest,
      this.profileImage,
      required this.imageName});

  factory UserInterest.fromJson(Map<String?, dynamic> json) =>
      _$UserInterestFromJson(json);
  Map<String?, dynamic> toJson() => _$UserInterestToJson(this);

  final int id;
  final String userId;
  final int interestId;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String location;
  final String? description;
  final String phoneNumber;
  final String birthday;
  final num age;
  final String sex;
  final String lastConnection;
  final String connected;
  final String interest;
  final String? profileImage;
  final String imageName;
}

class UsersInterests {
  UsersInterests({required this.userInterests});

  factory UsersInterests.fromJson(Map<String?, dynamic> json) =>
      _$UsersInterestsFromJson(json);
  Map<String?, dynamic> toJson() => _$UsersInterestsToJson(this);

  final List<UserInterest> userInterests;
}
