part of 'premium_plan.dart';

PremiumPlan _$PremiumPlanFromJson(Map<String?, dynamic> json) => PremiumPlan(
    id: json['id'],
    plan: json['plan'],
    price: json['price'],
    by: json["by"],
    description: json["description"],
    popular: json['popular']);

Map<String?, dynamic> _$PremiumPlanToJson(PremiumPlan instance) =>
    <String?, dynamic>{
      'id': instance.id,
      'plan': instance.plan,
      'price': instance.price,
      'by': instance.by,
      'description': instance.description,
      'popular': instance.popular,
    };
