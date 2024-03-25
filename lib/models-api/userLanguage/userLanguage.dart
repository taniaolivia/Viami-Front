import 'package:json_annotation/json_annotation.dart';

part 'userLanguage.l.dart';

@JsonSerializable()
class UserLanguage {
  UserLanguage({this.id, required this.languageId, this.userId});

  factory UserLanguage.fromJson(Map<String?, dynamic> json) =>
      _$UserLanguageFromJson(json);
  Map<String?, dynamic> toJson() => _$UserLanguageToJson(this);

  final String? id;
  final String languageId;
  final String? userId;
}
