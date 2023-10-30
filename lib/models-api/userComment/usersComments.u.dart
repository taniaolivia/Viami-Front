part of 'usersComments.dart';

UserComment _$UserCommentFromJson(Map<String?, dynamic> json) => UserComment(
      id: json['id'],
      userId: json["userId"],
      commenterId: json['commenterId'],
      commentId: json["commentId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
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
      comment: json['comment'],
    );

Map<String?, dynamic> _$UserCommentToJson(UserComment instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'commenterId': instance.commenterId,
      'commentId': instance.commentId,
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
      'comment': instance.comment
    };

UsersComments _$UsersCommentsFromJson(Map<String?, dynamic> json) =>
    UsersComments(
      userComments: (json['userComments'] as List<dynamic>)
          .map((e) => UserComment.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$UsersCommentsToJson(UsersComments instance) =>
    <String?, dynamic>{'userComments': instance.userComments};
