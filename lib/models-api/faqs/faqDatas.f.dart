part of 'faqDatas.dart';

Faqs _$FaqsFromJson(Map<String?, dynamic> json) => Faqs(
      faqs: (json['faq'] as List<dynamic>)
          .map((e) => Faq.fromJson(e as Map<String?, dynamic>))
          .toList(),
    );

Map<String?, dynamic> _$FaqsToJson(Faqs instance) =>
    <String?, dynamic>{'faq': instance.faqs};
