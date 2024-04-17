import 'package:json_annotation/json_annotation.dart';

part 'faqData.f.dart';

@JsonSerializable()
class Faq {
  Faq({
    required this.id,
    required this.question,
    required this.answer,
    required this.isFrequented,
  });

  factory Faq.fromJson(Map<String?, dynamic> json) => _$FaqFromJson(json);
  Map<String?, dynamic> toJson() => _$FaqToJson(this);

  final int id;
  final String question;
  final String answer;
  final int isFrequented;
}
