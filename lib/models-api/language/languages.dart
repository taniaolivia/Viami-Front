import 'package:json_annotation/json_annotation.dart';
import 'package:viami/models-api/language/language.dart';

part 'languages.l.dart';

@JsonSerializable()
class Languages {
  Languages({required this.languages});

  factory Languages.fromJson(Map<String?, dynamic> json) =>
      _$LanguagesFromJson(json);
  Map<String?, dynamic> toJson() => _$LanguagesToJson(this);

  final List<Language> languages;
}
