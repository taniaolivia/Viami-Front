import 'package:json_annotation/json_annotation.dart';

part 'language.l.dart';

@JsonSerializable()
class Language {
  Language({this.id, required this.language});

  factory Language.fromJson(Map<String?, dynamic> json) =>
      _$LanguageFromJson(json);
  Map<String?, dynamic> toJson() => _$LanguageToJson(this);

  final int? id;
  final String language;
}
