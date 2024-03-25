import 'package:json_annotation/json_annotation.dart';

import 'faqData.dart';

part 'faqDatas.f.dart';

@JsonSerializable()
class Faqs {
  Faqs({required this.faqs});

  factory Faqs.fromJson(Map<String?, dynamic> json) => _$FaqsFromJson(json);
  Map<String?, dynamic> toJson() => _$FaqsToJson(this);

  final List<Faq> faqs;
}
