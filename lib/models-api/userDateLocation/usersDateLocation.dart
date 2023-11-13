import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/userDateLocation/userDateLocation.dart';

part 'usersDateLocation.u.dart';

@JsonSerializable()
class UsersDateLocation {
  UsersDateLocation({required this.nbParticipant, required this.users});

  factory UsersDateLocation.fromJson(Map<String?, dynamic> json) =>
      _$UsersDateLocationFromJson(json);
  Map<String?, dynamic> toJson() => _$UsersDateLocationToJson(this);

  final int nbParticipant;
  final List<UserDateLocation> users;
}
