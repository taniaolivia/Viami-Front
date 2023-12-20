part of 'faqData.dart';

Faq _$FaqFromJson(Map<String?, dynamic> json) => Faq(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      isFrequented: json['isFrequented'],
    );

Map<String?, dynamic> _$FaqToJson(Faq instance) => <String?, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'isFrequented': instance.isFrequented,
    };
