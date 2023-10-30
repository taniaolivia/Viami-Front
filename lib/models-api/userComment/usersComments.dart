import 'package:json_annotation/json_annotation.dart';

part 'usersComments.u.dart';

@JsonSerializable()
class UserComment {
  UserComment(
      {required this.id,
      required this.userId,
      required this.commenterId,
      required this.commentId,
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
      this.profileImage,
      required this.comment});

  factory UserComment.fromJson(Map<String?, dynamic> json) =>
      _$UserCommentFromJson(json);
  Map<String?, dynamic> toJson() => _$UserCommentToJson(this);

  final int id;
  final String userId;
  final String commenterId;
  final int commentId;
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
  final String? profileImage;
  final String comment;
}

class UsersComments {
  UsersComments({required this.userComments});

  factory UsersComments.fromJson(Map<String?, dynamic> json) =>
      _$UsersCommentsFromJson(json);
  Map<String?, dynamic> toJson() => _$UsersCommentsToJson(this);

  final List<UserComment> userComments;
}
