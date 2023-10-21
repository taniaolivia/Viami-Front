import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/interest.dart';

part 'interests.i.dart';

@JsonSerializable()
class Interests {
  Interests({required this.interests});

  factory Interests.fromJson(Map<String?, dynamic> json) =>
      _$InterestsFromJson(json);
  Map<String?, dynamic> toJson() => _$InterestsToJson(this);

  final List<Interest> interests;
}
